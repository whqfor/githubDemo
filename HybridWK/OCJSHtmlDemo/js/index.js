function JSCallOCNormal() {

    location.href = 'wakaka://wahahalalala/callNativeNslog?param=1111';

    setTimeout(function(){
        location.href = 'wakaka://wahahalalala/callNativeNslog?param=2222';
    }, 500);

	// window.webkit.messageHandlers.HybridWKTest.postMessage({
    //
     //    "action": "alert",
     //    "message":  "JS调用OC方法无回调",
     //    "age":12,
     //    "arr":[1,2,3]
	// });
}

function JSCallOCSyncCallBack() {

    var arr = [1,2,3];
    var dict = {
        "name": "whqfor",
        "arr" : arr,
        "age" : 18
    }
    // 同步回掉 prompt
//   var params = sendSyncMessage(dict);
//   console.log(params);
//   alert(params);

    // 异步回调
     sendAsyncMessage(function(params) {

         console.log(params + 'sendAsyncMessage');
         alert(params);
     });

}


function JSCallOCAsyncCallBack() {
     // 异步回调 messageHandle
     window.webkit.messageHandlers.HybridWKTest.postMessage({

         "action": "changeBGColor",
         "color":"999999",
         "callback":"window.callbackDispatcher"
     });
}


function OCCallJSCallBack(data) {

    // alert(data);

    var arr = [1,2,3];
    var  dict = {
        "name": "whqfor",
        "arr" : arr,
        "age" : 18
    }
    return (arr);
}


function OCCallJSNormal(message) {

    alert(message + '56789');
}


// 同步回调
function sendSyncMessage (data) {

    var resultjson = prompt('prompt test');
    //直接用 = 接收 Prompt()的返回数据，JSON反解
    console.log(resultjson);
    return resultjson;
}

// 异步回调
function sendAsyncMessage (callback) {

    var resultjson = prompt('prompt test');
    //直接用 = 接收 Prompt()的返回数据，JSON反解
    callback(resultjson);
}


window.callbackDispatcher = function (callbackId, resultjson) {
   alert(resultjson);
}


window.applicationEnterBackground = function (callbackId, resultjson) {
    console.log(resultjson);
}



