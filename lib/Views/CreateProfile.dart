import 'dart:io';

import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'VerifyOTP.dart';

import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';


import 'package:shared_preferences/shared_preferences.dart';
//import 'package:device_info/device_info.dart';
import '../Views/Home.dart';
import '../Utils/AppColors.dart';
import 'AppLanguage.dart';





class CreateProfilePage extends StatefulWidget {
  final int myContentId;
  final String contentType;
  final String invitedBy;
  CreateProfilePage({Key key,@required this.myContentId,@required this.contentType,@required this.invitedBy}) : super(key: key);




  @override
  CreateProfilePageState createState() => CreateProfilePageState(myContentId,contentType,invitedBy);
}

class CreateProfilePageState extends State<CreateProfilePage> with WidgetsBindingObserver{
  int MyContentId;
  String mContentType;
  String mInvitedBy="";
  String _chosenValue="Select";
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  CreateProfilePageState(int contentId,String contentType,String invitedBy){
    MyContentId=contentId;
    mContentType=contentType;
    mInvitedBy=invitedBy;

  }

//  static final myTabbedPageKey = new GlobalKey<MyStatefulWidgetState>();

  final myControllerName = TextEditingController();
  final myControllerAge = TextEditingController();
  final myControllerPinCode= TextEditingController();

  String fcm_token;

  String baseOs;

  String manufacturer;

  String model;
  String ipAddress;

  String SCREEN_NAME="Login_Screen";
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Widget _entryFieldPincode(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerPinCode,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:"Your Postal PIN code",

              labelStyle: TextStyle(fontSize: 13,color: Colors.grey),
              hintStyle: TextStyle(fontSize: 13,color: Colors.black),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }
  Widget _entryFieldAge(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerAge,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:"Age",

              labelStyle: TextStyle(fontSize: 13,color: Colors.grey),
              hintStyle: TextStyle(fontSize: 13,color: Colors.black),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }

  Widget _entryFieldName(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerName,
            obscureText: false,
            style: TextStyle(color: Colors.black),

            decoration: InputDecoration(
              labelText:"Full Name",

              labelStyle: TextStyle(fontSize: 13,color: Colors.grey),
              hintStyle: TextStyle(fontSize: 13,color: Colors.black),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // myControllerContryCode.text="+91";



  }





  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.
    myControllerName.dispose();
    myControllerAge.dispose();
    myControllerPinCode.dispose();
    super.dispose();
  }



  showAlertDialogValidation(BuildContext context,String message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Constants.AppName),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }





  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(AppColors.StatusBarColor),//or set color with: Color(0xFF0000FF)
    ));
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView (
            child:
            Stack(
              alignment: Alignment.topCenter,
              children: [

                Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height/2)-20,


                    child: Container(


                      decoration: BoxDecoration(
                        color: Color(AppColors.BaseColor),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(40.0),
                            topLeft: Radius.circular(0.0),
                            bottomLeft: Radius.circular(40.0)),
                      ),

                    )


                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    new Image(
                      image: new AssetImage("assets/splash.png"),
                      width: 140,
                      height:  140,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),

                      child: Text(
                        'PROFILE',
                        style: TextStyle(
                          fontSize: 25.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height)*0.62,
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2,
                        margin: EdgeInsets.fromLTRB(30,10,30,10),
                        color: Color(0xFFffffff),

                        child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                          SizedBox(height: 18),



                          Padding(
                            padding: EdgeInsets.fromLTRB(10,8,10,9),
                            child:  Text("Create Profile", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10,8,10,0),
                            child:  Text("Please fill the details, all fields are \n required", textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 13,color: Colors.black)),
                          ),

                          _entryFieldName("Name"),
                          _entryFieldAge("Age"),
                          Align(
                            alignment: Alignment.topLeft,
                            child:   Padding(
                                padding: EdgeInsets.fromLTRB(10,9,10,0),
                                child:Text("Profession", style: TextStyle(fontSize: 11,color: Colors.grey))),

                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child:
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Colors.orange),
                                ),
                              ),

                            child:DropdownButtonHideUnderline(
                                child: Theme(
                                  data: new ThemeData(
                                    primaryColor: Colors.orange,
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor:Colors.orange,
                                    value: _chosenValue,
                                    //elevation: 5,
                                    style: TextStyle(color: Colors.white),
                                    iconEnabledColor:Colors.orange,
                                    items: <String>[
                                      'Select',
                                      'Government Employee',
                                      'Business-man',
                                      'Teacher',
                                      'Defence',

                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,style:TextStyle(color:Colors.black),),
                                      );
                                    }).toList(),
                                    hint:Text(
                                      "Please choose a langauage",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _chosenValue = value;
                                      });
                                    },
                                  ), // Your Dropdown Code Here,
                                )),

                            ),




                          ),
                         /* new Padding(
                              padding: EdgeInsets.fromLTRB(10,0,10,10),
                              child: new Divider(color: Colors.orange,)
                          ),*/

                        _entryFieldPincode("Pincode"),
                          _submitButton()
                        ]))),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
      /*  Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder:
                (context) =>
                HomePage()
            ), ModalRoute.withName("/HomePage")
        );*/
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return AppLanguagePage();
                }
            ) );

      },

      child: Container(
        width: 150,
        margin: EdgeInsets.fromLTRB(0,15,0,30),
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
                colors: [ Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'Next',
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




