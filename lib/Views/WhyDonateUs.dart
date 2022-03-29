import 'dart:convert';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../ApiResponses/AppChannelResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

class WhyDonateUsPage extends StatefulWidget {
  String link;
  String name;
  WhyDonateUsPage({Key key,@required this.link,@required this.name}) : super(key: key);


  @override
  WhyDonateUsPageState createState() {
    return WhyDonateUsPageState(link,name);
  }
}

class WhyDonateUsPageState extends State<WhyDonateUsPage> {
  // WebViewController _controller;
  String fileUrl="";
  // InAppWebViewController webView;
  // String url = "";
  double progress = 0;
  String link;
  String name;
    InAppWebViewController webView;

  WhyDonateUsPageState(String link,String name){
    this.link=link;
    this.name=name;
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,

        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp])
                  .then((_) {
                Navigator.of(context, rootNavigator: true).pop(context);
              })
            }
        ),
        backgroundColor: Color(AppColors.BaseColor),
        title: Text(name, style: GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 23,color: Color(0xFFFFFFFF))),

      ),
      body: link.isNotEmpty?SafeArea(child:Container(
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          child: Stack(

          children: <Widget>[InAppWebView(
        initialUrl: link,
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
            this.link = url;
          });
        },
        onLoadStop: (InAppWebViewController controller, String url) async {
          setState(() {
            this.link = url;
          });
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
      )]))):Container(),

    ),
      onWillPop: () => _exitApp(context));
  }
  Future<bool> _exitApp(BuildContext context) async {
    if (await webView.canGoBack()) {
      print("onwill goback");
      webView.goBack();
      return Future.value(false);
    } else {
      Scaffold.of(context).showSnackBar(
        const SnackBar(content: Text("No back history item")),
      );
      return Future.value(false);
    }
  }

}