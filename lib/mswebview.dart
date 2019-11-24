import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const MethodChannel webViewChanel = const MethodChannel('mswebview');

class MSWebView extends StatefulWidget {

  VoidCallback onStartCallback;
  VoidCallback onFinishCallback;
  ValueChanged<String> onErrorCallback;


  double height;

  String url;

  //是否允许在网页内播放，且不弹全屏
  bool allowsInlineMediaPlayback;

  MSWebView({Key key, this.url,  this.height, this.allowsInlineMediaPlayback=true,this.onStartCallback, this.onFinishCallback , this.onErrorCallback }) : super(key: key);

  @override
  MsWebViewState createState() => MsWebViewState();
}

class MsWebViewState extends State<MSWebView> {
  String url;

  Future<void> loadUrl(String url) async {
     webViewChanel.setMethodCallHandler((call)async{
       if(call.method == "onStart"){
         print("onStart ----");
         if(null != widget.onStartCallback) widget.onStartCallback();
       }else  if(call.method == "onFinish"){
         print("onFinish ----");

         if(null != widget.onFinishCallback) widget.onFinishCallback();

       }else  if(call.method == "onError"){
         print("onError ----");
         if(null != widget.onErrorCallback) widget.onErrorCallback(call.arguments["error"]);
       }
       return null;
     });
    webViewChanel.invokeMethod('loadUrl', {"url": url});
  }

  @override
  void initState() {
    url = widget.url;
    super.initState();
    Future((){
      loadUrl(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: widget.height??double.infinity,
      child: UiKitView(
        viewType: "ms_plugin_mswebview",
        onPlatformViewCreated: (id) {},
        creationParams: <String, dynamic>{
          "allowsInlineMediaPlayback":widget.allowsInlineMediaPlayback,
        },
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }


}
