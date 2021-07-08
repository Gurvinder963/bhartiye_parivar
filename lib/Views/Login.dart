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







class LoginPage extends StatefulWidget {
  final int myContentId;
  final String contentType;
  final String invitedBy;
  LoginPage({Key key,@required this.myContentId,@required this.contentType,@required this.invitedBy}) : super(key: key);




  @override
  LoginPageState createState() => LoginPageState(myContentId,contentType,invitedBy);
}

class LoginPageState extends State<LoginPage> with WidgetsBindingObserver{
  int MyContentId;
  String mContentType;
  String mInvitedBy="";
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  LoginPageState(int contentId,String contentType,String invitedBy){
    MyContentId=contentId;
    mContentType=contentType;
    mInvitedBy=invitedBy;

  }

//  static final myTabbedPageKey = new GlobalKey<MyStatefulWidgetState>();

  final myControllerPhone = TextEditingController();
  final myControllerContryCode = TextEditingController();

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
  Widget _emailPasswordWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _entryFieldCountryCode("Password", isPassword: true),
        SizedBox(width: 10),
        _entryField("Phone"),

      ],
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {


    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerPhone,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText:"Phone number",

              labelStyle: TextStyle(fontSize: 13,color: Colors.black),
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

              contentPadding: EdgeInsets.all(12),
            ),
          )
        ],
      ),
    );
  }

  Widget _entryFieldCountryCode(String title, {bool isPassword = false}) {

    myControllerContryCode.text="+91";
    return Container(
      width: 60,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerContryCode,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(


              labelStyle: TextStyle(fontSize: 13,color: Colors.black),
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

              contentPadding: EdgeInsets.all(12),
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

    myControllerContryCode.text="+91";



  }





  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.
    myControllerPhone.dispose();
    myControllerContryCode.dispose();
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
      statusBarColor: Colors.brown, //or set color with: Color(0xFF0000FF)
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
            height: MediaQuery.of(context).size.height/2,


        child: Container(


            decoration: BoxDecoration(
                color: Colors.orange,
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
                  width: 150,
                  height:  150,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),

                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 25.0,
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,

                    ),
                  ),
                ),
                Card( elevation: 2,
                    margin: EdgeInsets.fromLTRB(30,10,30,10),
                    color: Color(0xFFffffff),

                    child:Column( crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                      SizedBox(height: 20),



                      Padding(
                        padding: EdgeInsets.fromLTRB(10,10,10,10),
                        child:  Text("Verify your phone number", textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10,10,10,10),
                        child:  Text("We will send an sms to verify your \n phone number. Please enter your country code \n and phone number.", textAlign: TextAlign.center,
                            style: TextStyle( fontSize: 11,color: Colors.black)),
                      ),
                      CountryListPick(

                        appBar: AppBar(
                          backgroundColor: Colors.orange,
                          title: Text('Pick your country'),
                        ),

                        pickerBuilder: (context, CountryCode countryCode){
                          return Container(
                            margin: EdgeInsets.fromLTRB(20,0,20,0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Colors.orange),
                                ),
                              ),
                              child:
                          Row(
                            children: [
                              Image.asset(

                                countryCode.flagUri,
                                package: 'country_list_pick',
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 30),
                              Text(countryCode.name),

                            ],
                          ));
                        },
                        theme: CountryTheme(
                          isShowFlag: true,
                          isShowTitle: true,
                          isShowCode: false,
                          isDownIcon: true,
                          showEnglishName: true,
                        ),
                        initialSelection: '+91',
                        // or
                        // initialSelection: 'US'
                        onChanged: (CountryCode code) {
                          print(code.name);
                          print(code.code);
                          print(code.dialCode);
                          print(code.flagUri);
                        },
                      ),

                      _emailPasswordWidget(),
                      CheckboxListTile(
                        activeColor:Colors.black,
                        checkColor: Colors.orange,
                        title: Text("By signing in you are agreeing to our \n Terms and Privacy Policy.",
                            style: TextStyle(fontSize: 11, color: Colors.black)),
                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      ),
                      _submitButton()
                 ])),
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
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder:
                (context) =>
                    VerifyOTPPage()
            ), ModalRoute.withName("/VerifyOTP")
        );


      },

      child: Container(
        width: 150,
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
                colors: [Color(0xffFF8C00), Color(0xffFF8C00)])),
        child: Text(
          'Next',
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




