import 'dart:io';
import 'dart:math';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'VerifyOTP.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Repository/MainRepository.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../Views/privacyScreen.dart';
import '../Utils/AppStrings.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:device_info/device_info.dart';

import '../Utils/AppColors.dart';
import '../ApiResponses/OTPResponse.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../Views/terms.dart';



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
  //final controller =MaskedTextController(mask: "00000-00000");
   var myControllerPhone = MaskedTextController(mask: "00000 00000");
   var myControllerContryCode = TextEditingController();

  String fcm_token;

  String baseOs;

  String manufacturer;

  String model;
  String ipAddress;
 // String dialCode="+91";

  String SCREEN_NAME="Login_Screen";
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  Widget _emailPasswordWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20),
    Flexible(
    flex: 2,child:
        _entryFieldCountryCode("Password", isPassword: true)),
        SizedBox(width: 5),
        Flexible(
        flex: 5,child:
        _entryField("Phone")),

      ],
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerPhone,
            obscureText: false,
            style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 2.0,),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText:"Phone number",

              labelStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),
              hintStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),

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


    return Container(
      width: 60,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            enabled: false,
            controller: myControllerContryCode,
            obscureText: false,
            style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(


              labelStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),
              hintStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              contentPadding: EdgeInsets.all(5),
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
      statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1), //or set color with: Color(0xFF0000FF)
    ));

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.AppName,
        theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
    )
    ),

      home:SafeArea(
      child: Scaffold(

        body:
         ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.01,
        progressIndicator: CircularProgressIndicator(),
        child:

        SingleChildScrollView (
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
                    'Login',
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
               child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                   elevation: 6,  // Change this

                    margin: EdgeInsets.fromLTRB(30,10,30,10),
                    color: Color(0xFFffffff),

                    child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                      SizedBox(height: ScreenUtil().setWidth(20)),



                      Padding(
                        padding: EdgeInsets.fromLTRB(10,ScreenUtil().setHeight(9),10,9),
                        child:  Text("Verify your phone number", textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18),color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10,ScreenUtil().setWidth(9),10,28),
                        child:  Text("We will send an sms to verify your \n phone number. Please enter your country code and phone number.", textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(14),color: Colors.black)),
                      ),
                      CountryListPick(

                        appBar: AppBar(
                          backgroundColor: Color(AppColors.BaseColor),
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
                              SizedBox(width: 36),
                              Text(countryCode.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14),color: Colors.black)),
                             Expanded(child:
                              Align(
                                alignment: Alignment.topRight,
                                child:   Icon(Icons.arrow_drop_down,color: Colors.orange,size: 30,)
                              )),


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
                          myControllerContryCode.text=code.dialCode;
                          setState(() {
                           if(code.dialCode=='+91'){
                            myControllerPhone = MaskedTextController(mask: "00000 00000");

                           }
                           else{
                              myControllerPhone=MaskedTextController(mask: "000000000000000");

                           }
                          });

                        },
                      ),

                      _emailPasswordWidget(),
                    CheckboxListTile(
                          contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: ScreenUtil().setWidth(15)),
                          activeColor:Colors.orange,
                          checkColor: Colors.white,
                          title:
                          RichText(
                            text: TextSpan(


                              children:  <TextSpan>[
                                TextSpan(text: 'By signing in you are agreeing to our \n', style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Colors.black)),
                                TextSpan(text: ' Terms',
                                    recognizer: new TapGestureRecognizer()..onTap = () => {
                                      Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return TermScreen();
                                              }
                                          ) )

                                    },style: TextStyle( fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(14), color: Color(0xFF000080))),
                                TextSpan(text: ' and', style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Colors.black)),
                                TextSpan(text: ' Privacy Policy.',
                                    recognizer: new TapGestureRecognizer()..onTap = () => {
                                      Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return PrivacyScreen();
                                              }
                                          ) )

                                    }, style: TextStyle( fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(14), color:Color(0xFF000080))),
                              ],
                            ),
                          ),

                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
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
  Future<OTPResponse> getOTPData(String mobileNo,String msg) async {

    var body ={'user':'ravi10','password':'59034636','senderid':'NOTIFI','channel':'Trans','DCS':'0','flashsms':'0','number':mobileNo,'text':msg,'route':'15'};
    MainRepository repository=new MainRepository();
    return repository.fetchOTPData(body);

  }

  int nextIntOfDigits(int digitCount) {
    Random rnd = new Random();
    assert(1 <= digitCount && digitCount <= 9);
    int min = digitCount == 1 ? 0 : pow(10, digitCount - 1);
    int max = pow(10, digitCount);
    return min + rnd.nextInt(max - min);
  }


  Widget _submitButton() {
    return InkWell(
      onTap: () {

      if(myControllerPhone.text.isEmpty){
          showAlertDialogValidation(context, "Please enter mobile no!");
        }
      else if(!checkedValue){
        showAlertDialogValidation(context, "Please accept Terms and Privacy Policy!");
      }

        else {
        var s2 = myControllerContryCode.text.substring(1);
        print(s2);
        String mobile;
        if(s2=='91') {
          var arr = myControllerPhone.text.split(" ");
          String newStringMob = arr[0] + arr[1];

           mobile = s2 + newStringMob;
        }
        else{
           mobile=s2+myControllerPhone.text;
        }
        print(mobile);
        var pin=nextIntOfDigits(4);

        print(pin);
        var date1 = DateTime.now();
        if(s2=='91') {
          String msg = pin.toString() +
              " is your one-time password (OTP) for login into App. Valid for 5 minutes. Ignore if sent by Mistake.";
          setState(() {
            _isInAsyncCall = true;
          });

          getOTPData(mobile, msg).then((value) =>
          {

            setState(() {
              _isInAsyncCall = false;
            }),

            Navigator.of(context, rootNavigator: true)
                .push( // ensures fullscreen
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return VerifyOTPPage(c_code: s2,
                          mobile: myControllerPhone.text,
                          otpCode: pin.toString(),
                          otpSendDate: date1);
                    }
                ))
          });
        }
        else{
          Navigator.of(context, rootNavigator: true)
              .push( // ensures fullscreen
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return VerifyOTPPage(c_code: s2,
                        mobile: myControllerPhone.text,
                        otpCode: pin.toString(),
                        otpSendDate: date1);
                  }
              ));
        }



        }


      },

      child: Container(
        width: 150,
        height: ScreenUtil().setWidth(40),
        margin: EdgeInsets.fromLTRB(0,0,0,10),

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
          'NEXT',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




