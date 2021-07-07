import 'dart:io';

import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import '../Views/CreateProfile.dart';


import 'package:shared_preferences/shared_preferences.dart';
//import 'package:device_info/device_info.dart';







class VerifyOTPPage extends StatefulWidget {
  final int myContentId;
  final String contentType;
  final String invitedBy;
  VerifyOTPPage({Key key,@required this.myContentId,@required this.contentType,@required this.invitedBy}) : super(key: key);




  @override
  VerifyOTPPageState createState() => VerifyOTPPageState(myContentId,contentType,invitedBy);
}

class VerifyOTPPageState extends State<VerifyOTPPage> with WidgetsBindingObserver{
  int MyContentId;
  String mContentType;
  String mInvitedBy="";
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  VerifyOTPPageState(int contentId,String contentType,String invitedBy){
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






  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color:Color(0xffFFFFFF),
              ),
            ),
          ),
          Text('OR', style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                  thickness: 1,
                  color:Color(0xffFFFFFF)
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
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
                        'Verify',
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
                            child:  Text("Verify +91-9799125180", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.black)),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,10),
                            child:  Text("Not correct ?", textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 11,color: Colors.red)),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,10),
                            child:  Text("Waiting for automatically detect an SMS sent", textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 11,color: Colors.black)),
                          ),

                          SizedBox(height: 30),
                          OTPTextField(
                            length: 4,
                            width: 300,
                            fieldWidth: 40,
                            style: TextStyle(
                                fontSize: 14
                            ),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder:
                                      (context) =>
                                          CreateProfilePage()
                                  ), ModalRoute.withName("/CreateProfile")
                              );
                            },
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            child:  Text("Enter 4 DIGIT CODE", textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 13,color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10,40,10,10),
                            child:  Text("Didn't recieve the code ?", textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 13,color: Colors.black)),
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



      },

      child: Container(
        width: 250,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.orange)
        ),

        child: Text(
          'Give miss call to verify',
          style: TextStyle(fontSize: 18, color: Colors.orange,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xffea5d49);
    Path path = Path()
      ..relativeLineTo(0, 250)
      ..quadraticBezierTo(size.width / 2, 350.0, size.width, 250)
      ..relativeLineTo(0, -250)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}



