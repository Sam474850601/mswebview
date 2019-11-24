#import "MswebviewPlugin.h"
#import "WebViewFactory.h"
@implementation MswebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  MswebviewPlugin* instance = [[MswebviewPlugin alloc] init];
    WebViewFactory* factory =[[WebViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"ms_plugin_mswebview"];
  
}



@end
