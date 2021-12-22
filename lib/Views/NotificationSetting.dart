import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationSettingPage extends StatefulWidget {
  @override
  NotificationSettingPageState createState() {
    return NotificationSettingPageState();
  }
}

class NotificationSettingPageState extends State<NotificationSettingPage> {
  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Color(AppColors.BaseColor),
          title: Text('Notifications Settings', style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),


        ),
      body:ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.01,
        progressIndicator: CircularProgressIndicator(),
    child:   Container(
child:ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      SizedBox(height: 10,),
        ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          title: Row(
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text("Notifications"),
              )
              ,Expanded(child:Align(
                alignment: Alignment.centerRight,
                child: Switch(
                  value: true,
                  onChanged: (value) {

                  },
                  activeTrackColor: Colors.grey,
                  activeColor: Colors.orange,
                ),
              ))


            ],
          ),

        ),
      SizedBox(height: 10,),
      Divider(

        height: 1,

        thickness: 1,
        color: Color(AppColors.textBaseColor),
      ),
      SizedBox(height: 10,),
      ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Row(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text("Sound"),
            )
            ,Expanded(child:Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: true,
                onChanged: (value) {

                },
                activeTrackColor: Colors.grey,
                activeColor: Colors.orange,
              ),
            ))


          ],
        ),

      )
,  SizedBox(height: 10,),
      Divider(

        height: 1,

        thickness: 1,
        color: Color(AppColors.textBaseColor),
      ),
      SizedBox(height: 10,),

    ])


    ),
      )
    );
  }


}