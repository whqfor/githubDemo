//
//  Model.h
//  HybridWK
//
//  Created by whqfor on 2018/12/6.
//  Copyright © 2018年 whqfor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSNumber *date;
@property (nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END
