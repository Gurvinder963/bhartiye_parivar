import 'dart:io';

import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import '../Repository/MainRepository.dart';
import '../Views/CreateProfile.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Views/Home.dart';
//import 'package:device_info/device_info.dart';







class VerifyOTPPage extends StatefulWidget {

  final String mobile;
  final String c_code;
  final String otpCode;
  final DateTime otpSendDate;

  VerifyOTPPage({Key key,@required this.c_code,@required this.mobile,@required this.otpCode,@required this.otpSendDate}) : super(key: key);




  @override
  VerifyOTPPageState createState() => VerifyOTPPageState(mobile,c_code,otpCode,otpSendDate);
}

class VerifyOTPPageState extends State<VerifyOTPPage> with WidgetsBindingObserver{
  DateTime mOTPSendDate;
  int MyContentId;
  String mMobile;
  String mC_code;
  String mInvitedBy="";
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  String mOTPCode;
  VerifyOTPPageState(String mobile,String c_code,String otpCode,DateTime otpSendDate){
    mMobile=mobile;
    mC_code=c_code;
    mOTPCode=otpCode;
    mOTPSendDate=otpSendDate;
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
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1),  //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.AppName,
        theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
    )
    ),

    home:SafeArea(
      child: Scaffold(

        body:   ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:SingleChildScrollView (
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
                    SizedBox(
                        height: (MediaQuery.of(context).size.height)*0.17,
                        child:new Image(
                          image: new AssetImage("assets/splash.png"),
                          width: 140,
                          height:  140,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5.0),

                      child: Text(
                        'Verify',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(27),
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height)*0.67,
                        width: (MediaQuery.of(context).size.width)-10,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 6,

                        margin: EdgeInsets.fromLTRB(30,10,30,10),
                        color: Color(0xFFffffff),

                        child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                          SizedBox(height: 20),



                          Padding(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            child:  Text("Verify +"+mC_code+"-"+mMobile, textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18),color: Colors.black)),
                          ),

                          GestureDetector(
                              onTap: () =>
                              {
                                Navigator.of(context, rootNavigator: true).pop(context)

                              },child:Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,10),
                            child:  Text("Not correct ?", textAlign: TextAlign.center,
                                style:  GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14),color: Colors.red)),
                          )),

                          Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,10),
                            child:  Text("Waiting for automatically detect an SMS sent", textAlign: TextAlign.center,
                                style:  GoogleFonts.roboto( fontSize: ScreenUtil().setSp(14),color: Colors.black)),
                          ),

                          SizedBox(height: 30),

                          Theme(
                            data: ThemeData(
                              inputDecorationTheme: InputDecorationTheme(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                            child: OTPTextField(
                              length: 4,
                              width: 300,
                              fieldWidth: 40,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14)
                              ),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {


                                var date1 = DateTime.now();

                                final difference = date1.difference(mOTPSendDate);

                                if(difference.inMinutes>5){
                                  showAlertDialogValidation(context,"OTP has been expired!");
                                }
                                else if(pin!=mOTPCode){
                                  showAlertDialogValidation(context,"OTP not valid!");
                                }

                                else {

                                setState(() {
                                   _isInAsyncCall = true;
                                  });

                           getLoginResponse(mC_code,mMobile)
                              .then((res) async {
                                  setState(() {
                                    _isInAsyncCall = false;
                                  });


                                  if (res.status == 1) {

                                    SharedPreferences _prefs =await SharedPreferences.getInstance();


                                     Prefs.setUserLoginId(_prefs,(res.data.user.id).toString());
                                     Prefs.setUserLoginToken(_prefs,(res.data.token).toString());
                                     Prefs.setUserLoginName(_prefs,(res.data.user.fullName).toString());


                                    Timer(Duration(seconds: 1),
                                            ()=>Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(builder:
                                                (context) =>
                                                    HomePage()
                                            ), ModalRoute.withName("/Home")
                                        )
                                    );




                                  }
                                  else{

                                    Timer(Duration(seconds: 1),
                                            ()=>Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(builder:
                                                (context) =>
                                                    CreateProfilePage(c_code:mC_code,mobile:mMobile)
                                            ), ModalRoute.withName("/Profile")
                                        )
                                    );



                                  }


                                });





                              }


                                },
                            ),
                          ),




                          Padding(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            child:  Text("Enter 4 DIGIT CODE", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(13),color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10,40,10,10),
                            child:  Text("Didn't recieve the code ?", textAlign: TextAlign.center,
                                style: TextStyle( fontSize: ScreenUtil().setSp(13),color: Colors.black)),
                          ),
                          _submitButton()
                        ]))),
                  ],
                ),
              ],
            ))),
      ),
    ));
  }
  Future<LoginResponse> getLoginResponse(String contry_code,String mobile) async {
    var body =json.encode({"mobile_no":mobile,"country_code":contry_code});
    MainRepository repository=new MainRepository();
    return repository.fetchLoginData(body);

  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {



      },

      child: Container(
        width: 250,
        margin: EdgeInsets.fromLTRB(0,10,0,10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.orange)
        ),

        child: Text(
          'Give Miss Call to Verify',
          style: TextStyle(fontSize: 18, color:Color(AppColors.BaseColor),fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




