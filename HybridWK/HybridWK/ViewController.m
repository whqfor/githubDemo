//
//  ViewController.m
//  HybridWK
//
//  Created by whqfor on 2018/12/6.
//  Copyright © 2018年 whqfor. All rights reserved.
//

#import "ViewController.h"
#include <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property (weak, nonatomic) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWeb];
    
}

// 无回调
- (IBAction)OCCallJSNormal:(UIButton *)sender {
    
    // dict是一个字典，把字典序列化
//    NSString *paramsString = [self _serializeMessageData:dict];
     NSString *javascriptCommand = [NSString stringWithFormat:@"OCCallJSNormal('%@')", @"paramsString"];
    //要求必须在主线程执行JS
    if ([[NSThread currentThread] isMainThread]) {
        [self.webView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable bbb, NSError * _Nullable error) {
            NSLog(@" ====== ");
        }];
    } else {
        __strong typeof(self)strongSelf = self;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongSelf.webView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable aaaa, NSError * _Nullable error) {
                NSLog(@" ====== ");
            }];
        });
    }
}

// 有回调
- (IBAction)OCCallJSCallback:(UIButton *)sender {
    NSString *javascriptCommand = [NSString stringWithFormat:@"OCCallJSCallBack('%@')", @"paramsString"];
    
    [self.webView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"item %@", item);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:NSStringFromClass([item class]) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"HybridWKTest"]) {
        NSDictionary *params = message.body;
        NSLog(@"当前的body为： %@", params);
        
        if ([params[@"action"] isEqualToString:@"alert"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:params[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if ([params[@"action"] isEqualToString:@"changeBGColor"]) {
            
            NSInteger r = arc4random() % 256;
            self.view.backgroundColor = [UIColor colorWithRed:r/255. green:0.8 blue:0.8 alpha:1];
            
            NSString *javascriptCommand = [NSString stringWithFormat:@"%@('%@','%@')", params[@"callback"], @"id", @"callbackParams"];
            // messageHandler 异步方式回调
            sleep(1);
            NSLog(@"javascriptCommand   %@", javascriptCommand);
            if ([[NSThread currentThread] isMainThread]) {
                // 异步返回JS
                [self.webView evaluateJavaScript:javascriptCommand completionHandler:nil];
            } else {
                __strong typeof(self)strongSelf = self;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [strongSelf.webView evaluateJavaScript:javascriptCommand completionHandler:nil];
                });
            }
            
        }
    }
}


// 接收到输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    NSLog(@"InputPanelWithPrompt  %@ ", prompt);
    
    // 同步方式回调 给JS
    completionHandler(@"OC sync To JS");
}



//接收到警告面板
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)dealloc{
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"HybridWKTest"];
}


- (void)loadWeb
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    configuration.userContentController = userController;
    
    [userController addScriptMessageHandler:self name:@"HybridWKTest"];
    
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"index.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 300) configuration:configuration];
    [webView loadRequest: request];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    
//    WKUserScript 是预先准备好JS代码，当WKWebView加载Dom的时候，执行当条JS代码
//    evaluatingJavaScript 是在客户端执行这条代码的时候立刻去执行当条JS代码
    
//    WKUserScript *script = [[WKUserScript alloc]initWithSource:source injectionTime:time forMainFrameOnly:mainOnly];
//    [userController addUserScript:<#(nonnull WKUserScript *)#>];
    
    // The name of the message handler
    [self.view addSubview:webView];
    self.webView = webView;
}

@end
