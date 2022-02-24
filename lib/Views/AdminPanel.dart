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

class AdminPanelPage extends StatefulWidget {
  String link;
  String name;
  AdminPanelPage({Key key,@required this.link,@required this.name}) : super(key: key);


  @override
  AdminPanelPageState createState() {
    return AdminPanelPageState(link,name);
  }
}

class AdminPanelPageState extends State<AdminPanelPage> {
  // WebViewController _controller;
  String fileUrl="";
   InAppWebViewController webView;
  // String url = "";
  double progress = 0;
  String link;
  String name;

  AdminPanelPageState(String link,String name){
    this.link=link;
    this.name=name;
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("my urlll");
    print(link);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
      resizeToAvoidBottomInset: false,

      body: link.isNotEmpty? SafeArea(child:Container(
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          child: Stack(

          children: <Widget>[




      InAppWebView(
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
      ),
      Positioned.fill(
          child:Align(
              alignment: Alignment.topRight,
              child:GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop(context);

        },child:
      Container(
                  margin: EdgeInsets.fromLTRB(0,4,3,0),
                height: 35,width: 80,
                color:  Color(0xFFff0000),
                padding:EdgeInsets.fromLTRB(5,5,5,5),
                child:
                Center(child:Text("Logout",



                    style: GoogleFonts.roboto(
                      fontSize:14.0,


                      color: Color(0xFFffffff),
                      fontWeight: FontWeight.w500,

                    )),))))),

        ])))

        :Container(),

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