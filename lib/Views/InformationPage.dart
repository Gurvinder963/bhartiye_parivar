import 'dart:convert';

import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';


class InformationPage extends StatefulWidget {
  @override
  InformationPageState createState() {
    return InformationPageState();
  }
}


class InformationPageState extends State<InformationPage> {


  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('Information'),
      ),
      body:   Container(
          width: double.infinity ,
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.fromLTRB(10,30,10,10),
                  child:  Text("The Payment to this account goes to bhartiya pariwar which is registerd orgaination.The Payment to this account goes to bhartiya pariwar which is registerd orgaination.",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                ),

                _aboutButton(),
                _ContactButton(),

              ])

      ),

    );
  }
  Widget _aboutButton() {
    return InkWell(
      onTap: () {
        // Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
        //     MaterialPageRoute(
        //         builder: (BuildContext context) {
        //           return DonationHistoryPage();
        //         }
        //     ) );
      },

      child: Container(
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 1),
                  blurRadius: 0,
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'About '+Constants.AppName,
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  Widget _ContactButton() {
    return InkWell(
      onTap: () {
        // Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
        //     MaterialPageRoute(
        //         builder: (BuildContext context) {
        //           return DonationHistoryPage();
        //         }
        //     ) );
      },

      child: Container(
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 1),
                  blurRadius: 0,
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'Contact '+Constants.AppName,
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}