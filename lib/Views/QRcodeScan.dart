import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import '../Utils/AppColors.dart';
class QRcodeScanPage extends StatefulWidget {
  @override
  QRcodeScanPageState createState() {
    return QRcodeScanPageState();
  }
}

class QRcodeScanPageState extends State<QRcodeScanPage> {
  String USER_ID="";


  @override
  void initState() {
    super.initState();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {


      USER_ID=prefs.getString(Prefs.USER_ID);

      setState(() {});

      return (prefs.getString('token'));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
    title: Text("Scan Link"),
        ),
      body: Center(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

      Container(
        height: 200,
        child: SfBarcodeGenerator(
          value: 'https://sabkiapp.com:8443/web/scanqr.jsp?id='+USER_ID+'&app_code='+Constants.AppCode,
          symbology: QRCode(),
        ),
      ),
          Padding(
            padding: EdgeInsets.fromLTRB(0,20,0,0),

            child: Center(child:Text(
              'Scan this QR to install \n'+Constants.AppName+' App',
              textAlign:TextAlign.center ,
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 1.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,


              ),
            ),)
          ),
      ]
      )

      ),

    );
  }


}