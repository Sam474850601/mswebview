//
//  WebViewController.m
//  Runner
//
//  Created by sam on 2019/11/23.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebViewController.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)



@implementation WebViewController

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId
                        arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        [self initChanal:messenger];
        bool allowsInlineMediaPlayback =  [args[@"allowsInlineMediaPlayback"] boolValue];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

        if(allowsInlineMediaPlayback){
            config.allowsInlineMediaPlayback = YES;
            config.mediaPlaybackRequiresUserAction = false;
        }
        self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) configuration:config];
        
  

        self.webview.UIDelegate=self;
        self.webview.navigationDelegate=self;
    }
    
    return self;
}

//清除UIWebView的缓存
-(void)clearCache{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage   sharedHTTPCookieStorage];
    for (cookie in [storage cookies])  {
        [storage deleteCookie:cookie];
    }
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(void)initChanal:(NSObject<FlutterBinaryMessenger> *)messenger{
    self.channel = [FlutterMethodChannel methodChannelWithName:@"mswebview" binaryMessenger:messenger];
    __weak __typeof__(self) weakSelf = self;
    [self.channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
        [weakSelf onMethodCall:call result:result];
    }];
}

-(UIView *)view{
    return self.webview;
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    if ([[call method] isEqualToString:@"loadUrl"]) {
        [self clearCache];
        NSURL *url = [NSURL URLWithString:[call arguments][@"url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSString *header =@"<head>"
        "<meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'></meta> "
        "<style>body,html{width:100%;height:auto;}*{margin:0;padding:0;}</style></head>";
        NSString* html =@"<html>%@"
        "<body>"
        "<video autoplay preload='auto' webkit-playsinline='true' width='%g' height='auto' playsinline='true'  controls='controls'  src='%@'></video>"
        "</body>"
        "</html>"
        ;
        html = [NSString stringWithFormat:html, header, SCREEN_WIDTH,url];
        [self.webview loadHTMLString:html baseURL:nil];
    }else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
   
    NSLog(@"webViewDidStartLoad--------");
    [self.channel invokeMethod:@"onStart" arguments:@{}];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad--------");
    [self.channel invokeMethod:@"onFinish" arguments:@{}];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError-------");
    [self.channel invokeMethod:@"onError" arguments:@{@"error":error.description}];
}

@end
