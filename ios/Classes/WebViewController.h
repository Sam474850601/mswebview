//
//  WebViewController.h
//  Runner
//
//  Created by 李仁琅 on 2019/11/23.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#ifndef WebViewController_h
#define WebViewController_h
#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

@interface WebViewController : NSObject<FlutterPlatformView>
- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (void)initChanal:(NSObject<FlutterBinaryMessenger> *)messenger;

@end



@interface WebViewController ()

@property(nonatomic)WKWebView*  webview;
@property(nonatomic)FlutterMethodChannel* channel;

@end



#endif /* WebViewController_h */
