//
//  WKJSWebView.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/8.
//  Copyright © 2023 my. All rights reserved.
//

#import "WKJSWebView.h"
#import <objc/runtime.h>
#import "MJExtension.h"

static NSString * const EASY_JS_INJECT_STRING = @"!function () {\
    if (window.EasyJS) {\
        return;\
    }\
    window.EasyJS = {\
        __callbacks: {},\
        __events: {},\
        mount: function (funcName, handler) {\
            EasyJS.__events[funcName] = handler;\
        },\
        invokeJS: function (funcID, paramsJson) {\
            let handler = EasyJS.__events[funcID];\
            if (handler && typeof (handler) === 'function') {\
                let args = '';\
                try {\
                    if (typeof JSON.parse(paramsJson) == 'object') {\
                        args = JSON.parse(paramsJson);\
                    } else {\
                        args = paramsJson;\
                    }\
                    return handler(args);\
                } catch (error) {\
                    console.log(error);\
                    args = paramsJson;\
                    return handler(args);\
                }\
            } else {\
               console.log(funcID + '函数未定义');\
            }\
        },\
        invokeCallback: function (cbID, removeAfterExecute) {\
            let args = Array.prototype.slice.call(arguments);\
            args.shift();\
            args.shift();\
            for (let i = 0, l = args.length; i < l; i++) {\
                args[i] = decodeURIComponent(args[i]);\
            }\
            let cb = EasyJS.__callbacks[cbID];\
            if (removeAfterExecute) {\
                EasyJS.__callbacks[cbID] = undefined;\
            }\
            return cb.apply(null, args);\
        },\
        call: function (obj, functionName, args) {\
            let formattedArgs = [];\
            for (let i = 0, l = args.length; i < l; i++) {\
                if (typeof args[i] == 'function') {\
                    formattedArgs.push('f');\
                    let cbID = '__cb' + (+new Date) + Math.random();\
                    EasyJS.__callbacks[cbID] = args[i];\
                    formattedArgs.push(cbID);\
                } else {\
                    formattedArgs.push('s');\
                    formattedArgs.push(encodeURIComponent(args[i]));\
                }\
            }\
            let argStr = (formattedArgs.length > 0 ? ':' + encodeURIComponent(formattedArgs.join(':')) : '');\
            window.webkit.messageHandlers.NativeListener.postMessage(obj + ':' + encodeURIComponent(functionName) + argStr);\
            let ret = EasyJS.retValue;\
            EasyJS.retValue = undefined;\
            if (ret) {\
                return decodeURIComponent(ret);\
            }\
        },\
        inject: function (obj, methods) {\
            window[obj] = {};\
            let jsObj = window[obj];\
            for (let i = 0, l = methods.length; i < l; i++) {\
                (function () {\
                    let method = methods[i];\
                    let jsMethod = method.replace(new RegExp(':', 'g'), '');\
                    jsObj[jsMethod] = function () {\
                        return EasyJS.call(obj, method, Array.prototype.slice.call(arguments));\
                    };\
                })();\
            }\
        }\
    };\
}()";

static NSString * const WKJSMessageHandler = @"NativeListener";


#pragma mark - WKJSWebView

@implementation WKJSWebView

/**
 初始化WKWwebView,并将交互类的方法注入JS
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration*)configuration scripts:(NSArray<NSString*>*)scripts withJavascriptInterfaces:(NSDictionary*)interfaces
{
    if (!configuration) {
        configuration = [[WKWebViewConfiguration alloc] init];
    }
    if (!configuration.userContentController) {
        configuration.userContentController = [[WKUserContentController alloc] init];
    }
    
    // add script
    for (NSString* script in scripts) {
        [configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    }
    
    [configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:EASY_JS_INJECT_STRING injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    
    NSMutableString* injectString = [[NSMutableString alloc] init];
    for(NSString *key in [interfaces allKeys]) {
        [injectString appendString:@"EasyJS.inject(\""];
        [injectString appendString:key];
        [injectString appendString:@"\", ["];
        NSObject* interfaceObj = [interfaces objectForKey:key];
        if ([interfaceObj isKindOfClass:[NSObject class]]) {
            Class cls = object_getClass(interfaceObj);
            while (cls != [NSObject class]) {
                unsigned int mc = 0;
                Method * mlist = class_copyMethodList(cls, &mc);
                for (int i = 0; i < mc; i++) {
                    [injectString appendString:@"\""];
                    [injectString appendString:[NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))]];
                    [injectString appendString:@"\""];
                    if ((i != mc - 1) || (cls.superclass != [NSObject class])) {
                        [injectString appendString:@", "];
                    }
                }
                free(mlist);
                cls = cls.superclass;
            }
        }
        [injectString appendString:@"]);"]; //@"EasyJS.inject(\"native\", [\"testWithParams:callback:\"]);"
    }
#ifdef DEBUG
    NSLog(@"injectString :\n%@", injectString);
#endif
    [configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:injectString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    
    // add message handler
    WKJSListener *listener = [[WKJSListener alloc] init];
    listener.javascriptInterfaces = interfaces;
    [configuration.userContentController addScriptMessageHandler:listener name:WKJSMessageHandler];
    
    // init
    self = [super initWithFrame:frame configuration:configuration];
    return self;
}

- (void)wk_evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self evaluateJavaScript:javaScriptString completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                if (completionHandler) {completionHandler(response, error);}
            }];
        });
    } else {
        [self evaluateJavaScript:javaScriptString completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            if (completionHandler) {completionHandler(response, error);}
        }];
    }
}

- (void)invokeJSFunction:(NSString*)jsFuncName params:(id)params completionHandler:(void (^)(id response, NSError *error))completionHandler {
    
    NSString *paramJson = @"";
    if (params) {  paramJson = [params mj_JSONString]; }
    paramJson = [paramJson stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    paramJson = [paramJson stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    paramJson = [paramJson stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    paramJson = [paramJson stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    paramJson = [paramJson stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    paramJson = [paramJson stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    paramJson = [paramJson stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString *script = [NSString stringWithFormat:@"%@('%@', '%@')", @"window.EasyJS.invokeJS", jsFuncName,  paramJson];
    [self wk_evaluateJavaScript:script completionHandler:completionHandler];
}

@end


#pragma mark - WKJSListener

@implementation WKJSListener

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSMutableArray <WKJSDataFunction *>* _funcs = [NSMutableArray new];
    NSMutableArray <NSString *>* _args = [NSMutableArray new];
    
    if ([message.name isEqualToString:WKJSMessageHandler]) {
        __weak WKJSWebView *webView = (WKJSWebView *)message.webView;
        NSString *requestString = [message body];
        // native:testWithParams%3Acallback%3A:s%3Aabc%3Af%3A__cb1577786915804
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        //NSLog(@"req: %@", requestString);
        
        NSString* obj = (NSString*)[components objectAtIndex:0];
        NSString* method = [(NSString*)[components objectAtIndex:1] stringByRemovingPercentEncoding];
        NSObject* interface = [self.javascriptInterfaces objectForKey:obj];
        
        // execute the interfacing method
        SEL selector = NSSelectorFromString(method);
        NSMethodSignature* sig = [interface methodSignatureForSelector:selector];
        if (sig.numberOfArguments == 2 && components.count > 2) {
            // 方法签名获取到实际实现的方法无参数 && js调用的方法带参数
            NSString *assertDesc = [NSString stringWithFormat:@"*** -[%@ %@]: %@",NSStringFromClass([interface class]),method,@"oc的交互方法不带参数，但是js调用的方法传了参数"];
            //  因为pod报警告，所以加上这句，实际没有意义
            assertDesc = assertDesc ? : @"";
            NSAssert(NO, assertDesc);
            return;
        }
        if (!sig) {
            NSString *assertDesc = [NSString stringWithFormat:@"*** -[%@ %@]:%@",NSStringFromClass([interface class]),method,@"method signature argument cannot be nil"];
            NSAssert(NO, assertDesc);
            return;
        }
        if (![interface respondsToSelector:selector]) {
            NSAssert(NO, @"该方法未实现");
            return;
        }
        
        NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
        invoker.selector = selector;
        invoker.target = interface;
        if ([components count] > 2){
            NSString *argsAsString = [(NSString*)[components objectAtIndex:2] stringByRemovingPercentEncoding];
            NSArray* formattedArgs = [argsAsString componentsSeparatedByString:@":"];
            if ((sig.numberOfArguments - 2) != [formattedArgs count] / 2) {
                // 方法签名获取到实际实现的方法的参数个数 != js调用方法时传参个数
                NSString *assertDesc = [NSString stringWithFormat:@"*** -[%@ %@]: oc的交互方法参数个数%@，js调用方法时传参个数%@",NSStringFromClass([interface class]),method,@(sig.numberOfArguments - 2),@([formattedArgs count] / 2)];
                //  因为pod报警告，所以加上这句，实际没有意义
                assertDesc = assertDesc ? : @"";
                NSAssert(NO, assertDesc);
                return;
            }
            for (unsigned long i = 0, j = 0, l = [formattedArgs count]; i < l; i+=2, j++){
                NSString* type = ((NSString*) [formattedArgs objectAtIndex:i]);
                NSString* argStr = ((NSString*) [formattedArgs objectAtIndex:i + 1]);
                
                if ([@"f" isEqualToString:type]){
                    WKJSDataFunction *func = [[WKJSDataFunction alloc] initWithWebView:webView];
                    func.funcID = argStr;
                    //do this to force retain a reference to it
                    [_funcs addObject:func];
                    [invoker setArgument:&func atIndex:(j + 2)];
                }else if ([@"s" isEqualToString:type]){
                    NSString* arg = [argStr stringByRemovingPercentEncoding];
                    //do this to force retain a reference to it
                    [_args addObject:arg];
                    [invoker setArgument:&arg atIndex:(j + 2)];
                }
            }
        }
        [invoker retainArguments];
        [invoker invoke];
        
        //return the value by using javascript
        if ([sig methodReturnLength] > 0){
            __unsafe_unretained NSString* tmpRetValue;
            [invoker getReturnValue:&tmpRetValue];
            NSString *retValue = tmpRetValue;
            
            if (retValue == NULL || retValue == nil){
                [webView wk_evaluateJavaScript:@"EasyJS.retValue=null;" completionHandler:nil];
            }else{
                retValue = [retValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
                retValue = [@"" stringByAppendingFormat:@"EasyJS.retValue=\"%@\";", retValue];
                [webView wk_evaluateJavaScript:retValue completionHandler:nil];
            }
        }
    }
    
    //clean up any retained funcs
    [_funcs removeAllObjects];
    //clean up any retained args
    [_args removeAllObjects];
}

@end

#pragma mark - WKJSDataFunction

@implementation WKJSDataFunction

- (instancetype)initWithWebView:(WKJSWebView *)webView {
    self = [super init];
    if (self) {
        _webView = webView;
    }
    return self;
}

- (void)execute:(void (^)(id response, NSError *error))completionHandler {
    [self executeWithParam:nil completionHandler:^(id response, NSError *error) {
        if (completionHandler) {
            completionHandler(response, error);
        }
    }];
}

- (void)executeWithParam:(NSString *)param completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [self executeWithParams:param ? @[param] : nil completionHandler:^(id response, NSError *error) {
        if (completionHandler) {
            completionHandler(response, error);
        }
    }];
}

- (void)executeWithParams:(NSArray *)params completionHandler:(void (^)(id response, NSError *error))completionHandler {
    
    NSMutableArray * args = [NSMutableArray arrayWithArray:params];
    for (int i=0; i<params.count; i++) {
        NSString* json = [params[i] mj_JSONString];
        [args replaceObjectAtIndex:i withObject:json];
    }
    
    NSMutableString* injection = [[NSMutableString alloc] init];
    [injection appendFormat:@"EasyJS.invokeCallback(\"%@\", %@", self.funcID, self.removeAfterExecute ? @"true" : @"false"];
    
    if (args) {
        for (unsigned long i = 0, l = args.count; i < l; i++){
            NSString* arg = [args objectAtIndex:i];
            NSCharacterSet *chars = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
            NSString *encodedArg = [arg stringByAddingPercentEncodingWithAllowedCharacters:chars];
            [injection appendFormat:@", \"%@\"", encodedArg];
        }
    }
    
    [injection appendString:@");"];
    
    if (_webView){
        [_webView wk_evaluateJavaScript:injection completionHandler:^(id response, NSError *error) {
            if (completionHandler) {completionHandler(response, error);}
        }];
    }
}

@end
