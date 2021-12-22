import 'dart:convert';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../ApiResponses/AppChannelResponse.dart';
import '../Repository/MainRepository.dart';

class FacebookPage extends StatefulWidget {
  @override
  FacebookPageState createState() {
    return FacebookPageState();
  }
}

class FacebookPageState extends State<FacebookPage> {
  // WebViewController _controller;
  String fileUrl="";
  // InAppWebViewController webView;
  String url = "";
  double progress = 0;

  Future<AppChannelResponse> getAppChannelAPI() async {

    var body ={'app_code':Constants.AppCode};
    MainRepository repository=new MainRepository();
    return repository.fetchAppChannel(body);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppChannelAPI().then((value) => {

      if(value.data!=null && value.data.length>0){
        setState(() {
          url= value.data[0].facebookPageLink;

        })

      }



    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: url.isNotEmpty?InAppWebView(
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
      ):Container(),

    );
  }


}