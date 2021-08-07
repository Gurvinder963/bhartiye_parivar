import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class PrivacyScreen extends StatefulWidget {


  @override
  PrivacyScreenState createState() {
    return PrivacyScreenState();
  }
}

class PrivacyScreenState extends State<PrivacyScreen> {
  WebViewController _controller;
  String fileUrl="";
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _loadHtmlFromAssets();


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body:
      InAppWebView(
        initialUrl: fileUrl,
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
        onLoadStart: (InAppWebViewController controller, String url) {
          setState(() {
            this.url = url;
          });
        },
        onLoadStop: (InAppWebViewController controller, String url) async {
          setState(() {
            this.url = url;
          });
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
      ),
      /*WebView(

        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),*/
    );
  }


  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/BankonKaMayajaal/Bankjaal.html');
    setState(() {
      fileUrl = fileText;
    });
  /*  _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());*/
  }
}