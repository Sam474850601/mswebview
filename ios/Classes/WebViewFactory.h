//
//  WebViewFactory.h
//  Runner
//
//  Created by sam on 2019/11/23.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//


#ifndef WebViewFactory_h
#define WebViewFactory_h

#import <Flutter/Flutter.h>


@interface WebViewFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end


@interface WebViewFactory()
@property(nonatomic)NSObject<FlutterBinaryMessenger>* messenger;
@end



#endif /* WebViewFactory_h */
