import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:bookadministration/utils/ScreenAdapter.dart';

class WebPage extends StatefulWidget {
  String url;
  WebPage(this.url);
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {

  String title;
  bool webload;
  double webopacity;
  @override
  void initState() {
    title = '加载中……';
    webload = false;
    webopacity = 1.0;
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            child: InAppWebView(
              initialUrl: widget.url,
              initialHeaders: {},
              initialOptions: InAppWebViewWidgetOptions(
                  inAppWebViewOptions: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                print('----------------------------网页创建时---------------------------------');
                controller.getTitle().then((val){
                  print(val);
                });
              },
              onLoadStart: (InAppWebViewController controller, String url) async {
                print('----------------------------网页加载时---------------------------------');
                
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                print('----------------------------网页加载完毕后---------------------------------');
                var a = await controller.getTitle();
                setState(() {
                  title = a;
                  webload = true;
                  webopacity = 0;
                });
              },
            )),
          Positioned(
            child: Opacity(
              opacity: webopacity,
              child: Center(
                    child: CircularProgressIndicator(),
                  )
            ),
          )
        ],
      )
      
    );
  }
}
