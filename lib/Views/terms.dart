import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Utils/AppColors.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TermScreen extends StatefulWidget {
  @override
  TermScreenState createState() {
    return TermScreenState();
  }
}

class TermScreenState extends State<TermScreen> {
  WebViewController _controller;
  String url = "https://sabkiapp.com:8443/app/termpolicy.jsp";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( toolbarHeight: 50,
          backgroundColor: Color(AppColors.BaseColor),title: Text('Terms & Privacy Policy')),
      body: InAppWebView(
        initialUrl: url,
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          //  webView = controller;
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
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/terms.html');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}