import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:google_fonts/google_fonts.dart';
class ViewOnlineBookPage extends StatefulWidget {


  @override
  ViewOnlineBookPageState createState() {
    return ViewOnlineBookPageState();
  }
}

class ViewOnlineBookPageState extends State<ViewOnlineBookPage> {
  WebViewController _controller;
  String fileUrl="";
  // InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([

      DeviceOrientation.portraitUp,

    ]);
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();


    //  _loadHtmlFromAssets();


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text(AppStrings.Details, style: GoogleFonts.poppins(fontSize: 22,color: Color(0xFFFFFFFF))),



      ),
      body:
      InAppWebView(
        initialUrl: 'http://bankjaal.in/bankon_ka_mayajaal/mobile/index.html',
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
      /* HtmlWidget(

        "http://bankjaal.in/bankon_ka_mayajaal/mobile/index.html",
        webView: true,
      )*/
      /*  WebView(

        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),*/
    );
  }


  _loadHtmlFromAssets() async {
    //  String fileText = await rootBundle.loadString('assets/BankonKaMayajaal/mobile/index.html');
    /* setState(() {
      fileUrl = fileText;
    });*/
    _controller.loadUrl('http://bankjaal.in/bankon_ka_mayajaal/mobile/index.html');
  }
}