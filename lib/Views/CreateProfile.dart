import 'dart:io';

import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'VerifyOTP.dart';
import '../ApiResponses/OTPResponse.dart';
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
import '../Utils/AppStrings.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/LoginResponse.dart';
import '../ApiResponses/PinCodeResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info_plus/device_info_plus.dart';




class CreateProfilePage extends StatefulWidget {
  final String mobile;
  final String c_code;
  CreateProfilePage({Key key,@required this.c_code,@required this.mobile}) : super(key: key);




  @override
  CreateProfilePageState createState() => CreateProfilePageState(mobile,c_code);
}

class CreateProfilePageState extends State<CreateProfilePage> with WidgetsBindingObserver{
  int MyContentId;
  String mContentType;
  String mInvitedBy="";
  String mMobile;
  String mC_code;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String mAddress='';
  String _chosenValue="Select";
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  CreateProfilePageState(String mobile,String c_code){
    mMobile=mobile;
    mC_code=c_code;

  }

//  static final myTabbedPageKey = new GlobalKey<MyStatefulWidgetState>();

  final myControllerName = TextEditingController();
  final myControllerAge = TextEditingController();
  final myControllerPinCode= TextEditingController();

  String fcm_token;
  String user_Token;
  String USER_NAME=null;

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

  Future<PinCodeResponse> getPinAddressAPI(String pin) async {

    var body ={'pin_code':pin};
    MainRepository repository=new MainRepository();
    return repository.fetchPinAddress(body);

  }
  Widget _entryFieldPincode(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            onChanged: (text) {
             if(text.length>5){
               FocusScope.of(context).requestFocus(FocusNode());
               getPinAddressAPI(text).then((value) => {



                 if(value.status==1){
                   setState(() {
                     if(value.data.address!=null) {
                       mAddress = value.data.address.postOffice + ", " +
                           value.data.address.district + ", " +
                           value.data.address.region;
                     }
                     else{
                       mAddress="Address not found!";
                     }


                     }),
                 }
                 else{
                   showAlertDialogValidation(context,"pin not valid")
                 }



               });

             }
             else{
               setState(() {
                 mAddress="";
               });
             }


            },
            inputFormatters: [
              new LengthLimitingTextInputFormatter(6),
            ],
            keyboardType: TextInputType.number,
            controller: myControllerPinCode,
            obscureText: false,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),

            decoration: InputDecoration(
              labelText:"Your Postal PIN code",

              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.grey,fontWeight: FontWeight.w700),
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.black,fontWeight: FontWeight.w700),

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

      margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerAge,
            obscureText: false,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:"Age",

              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.grey,fontWeight: FontWeight.w700),
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.black,fontWeight: FontWeight.w700),

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

      margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[ ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]"))],
            textCapitalization: TextCapitalization.sentences,
            controller: myControllerName,
            obscureText: false,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),

            decoration: InputDecoration(
              labelText:"Full Name",

              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.grey,fontWeight: FontWeight.w700),
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.black,fontWeight: FontWeight.w700),

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
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {
      print(prefs.getString('token'));
      fcm_token=prefs.getString('fcm_token');
      user_Token=prefs.getString(Prefs.KEY_TOKEN);
       USER_NAME=prefs.getString(Prefs.USER_NAME);
      if(USER_NAME!=null && USER_NAME.isNotEmpty) {
        print(USER_NAME);
        myControllerName.text = USER_NAME;
        String USER_AGE = prefs.getString(Prefs.USER_AGE);
        myControllerAge.text = USER_AGE;
        String USER_PROFESSION = prefs.getString(Prefs.USER_PROFESSION);
        String USER_POSTAL = prefs.getString(Prefs.USER_POSTAL);
        myControllerPinCode.text = USER_POSTAL;
        _chosenValue = USER_PROFESSION;
        print("fcm_token" + mMobile);
      }
      initPlatformState();


      return (prefs.getString('fcm_token'));
    });



  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        print('Running on ${deviceData}');
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }



  _readAndroidBuildData(AndroidDeviceInfo build) {

    baseOs=build.version.release;
    manufacturer=build.manufacturer;
    model= build.model;


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
      statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1),//or set color with: Color(0xFF0000FF)
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

        body:  ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child: SingleChildScrollView (
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
                      height: (MediaQuery.of(context).size.height)*0.15,
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
                        'PROFILE',
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
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 6,
                        margin: EdgeInsets.fromLTRB(30,6,30,8),
                        color: Color(0xFFffffff),

                        child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                          SizedBox(height: 18),



                          Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,8),
                            child:  Text("Create Profile", textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18),color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,0),
                            child:  Text("Please fill the details, all fields are \n required", textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14),color: Colors.black)),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                          _entryFieldName("Name"),
                          _entryFieldAge("Age"),
                          Align(
                            alignment: Alignment.topLeft,
                            child:   Padding(
                                padding: EdgeInsets.fromLTRB(15,12,10,0),
                                child:Text("Profession", style: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.grey,fontWeight: FontWeight.w700))),

                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(15,0,10,0),
                            child:
                            Container(
                              height: 35,
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
                                      "Please choose a Profession",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ScreenUtil().setSp(14),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (String value) {
                                      FocusScope.of(context).requestFocus(FocusNode());
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

                          mC_code=='91'?_entryFieldPincode("Pincode"):Container(),
                          mC_code=='91'&& !mAddress.isEmpty?
                          Padding(
                              padding: EdgeInsets.fromLTRB(15,0,0,0),
                              child: Text(mAddress, style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(12), color: Colors.red,fontWeight: FontWeight.bold)
                          )
                          ):Container(),

                        ]),  _submitButton()
                        ]))),
                  ],
                ),
              ],
            ))),
      ),
    ));
  }
  Future<LoginResponse> getProfileResponse(String name,String age,String profession,String pincode,String mobile,String cCode) async {


    String varMobile="";
    if(cCode=='91') {
      var arr = mobile.split(" ");
      String newStringMob = arr[0] + arr[1];

      varMobile = newStringMob;
    }
    else{
      varMobile=mobile;
    }
    var body =json.encode({"full_name":name,"age":age,"address":pincode,"profession":profession,"country_code":cCode,"mobile_no":varMobile,"email":"","fcm_token":fcm_token,"app_name":Constants.AppName,"app_version":"1.1","device_version":baseOs,"device_model":model,"device_type":"Android","device_name":manufacturer,"app_unique_code":Constants.AppCode});
    MainRepository repository=new MainRepository();
    return repository.fetchProfileData(body);

  }

  Future<LoginResponse> getProfileUpdateResponse(String name,String age,String profession,String pincode,String mobile,String cCode) async {


    String varMobile="";
    // if(cCode=='91' && USER_NAME==null) {
    //   var arr = mobile.split(" ");
    //   String newStringMob = arr[0] + arr[1];
    //
    //   varMobile = newStringMob;
    // }
    // else{
      varMobile=mobile;
    //}
    var body =json.encode({"full_name":name,"age":age,"address":pincode,"profession":profession,"country_code":cCode,"mobile_no":varMobile,"email":"","fcm_token":fcm_token,"app_name":Constants.AppName,"app_version":"1.1","device_version":baseOs,"device_model":model,"device_type":"Android","device_name":manufacturer});
    MainRepository repository=new MainRepository();
    return repository.fetchUpdateProfileData(body,user_Token);

  }



  Future<AddToCartResponse> getNationalProfile(String id,String token) async {

    var body =json.encode({'userid':id,"appcode":Constants.AppCode,"token":token});

    MainRepository repository=new MainRepository();
    return repository.fetchCreateProfileNational(body);

  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {

        var age=0;
        if(myControllerAge.text.isNotEmpty){
          String userage=myControllerAge.text.toString();
          age=int.parse(userage);
        }



        if(myControllerName.text.isEmpty){
          showAlertDialogValidation(context, "Please enter name!");
        }
        else if(myControllerName.text.length<3){
          showAlertDialogValidation(context, "Name length at least 3 character!");
        }

        else if(myControllerAge.text.isEmpty){
          showAlertDialogValidation(context, "Please enter age!");
        }
        else if(age<18 || age>125){
          showAlertDialogValidation(context, "your age not satisfy the Terms & policy requirements!");
        }

        else if(_chosenValue=='Select'){
          showAlertDialogValidation(context, "Please select profession!");
        }
        else if(mC_code=='91' && myControllerPinCode.text.isEmpty){
          showAlertDialogValidation(context, "Please enter pincode!");
        }
        else if(mC_code=='91' && myControllerPinCode.text.length<6){
          showAlertDialogValidation(context, "Pincode not valid!");
        }
        else {
          setState(() {
            _isInAsyncCall = true;
          });

          String postal="999999";
          if(mC_code=='91'){
            postal=myControllerPinCode.text;
          }
          if(USER_NAME!=null){
            print("update profile");
            getProfileUpdateResponse(myControllerName.text, myControllerAge.text,
                _chosenValue, postal, mMobile, mC_code)
                .then((res) async {
              setState(() {
                _isInAsyncCall = false;
              });


              if (res.status == 1) {

                SharedPreferences _prefs = await SharedPreferences
                    .getInstance();


                Prefs.setUserLoginId(_prefs, (res.data.user.id).toString());
                //Prefs.setUserLoginToken(_prefs, (res.data.token).toString());
                Prefs.setUserLoginName(
                    _prefs, (res.data.user.fullName).toString());
                Prefs.setUserAge(_prefs, (res.data.user.age).toString());
                Prefs.setUserProfession(
                    _prefs, (res.data.user.profession).toString());
                Prefs.setUserPostal(_prefs, (res.data.user.address).toString());

                Prefs.setUserMobile(
                    _prefs, (res.data.user.mobileNo).toString());
                Prefs.setUserCCode(
                    _prefs, (res.data.user.country_code).toString());

                Navigator.of(context, rootNavigator: true).pop(context);

              }
              else {

              }
            });

          }

          else {
            getProfileResponse(myControllerName.text, myControllerAge.text,
                _chosenValue, postal, mMobile, mC_code)
                .then((res) async {
              setState(() {
                _isInAsyncCall = false;
              });


              if (res.status == 1) {
                getNationalProfile(res.data.user.id.toString(),res.data.token.toString()).then((value) =>
                {
                });


                SharedPreferences _prefs = await SharedPreferences
                    .getInstance();


                Prefs.setUserLoginId(_prefs, (res.data.user.id).toString());
                Prefs.setUserLoginToken(_prefs, (res.data.token).toString());
                Prefs.setUserLoginName(
                    _prefs, (res.data.user.fullName).toString());
                Prefs.setUserAge(_prefs, (res.data.user.age).toString());
                Prefs.setUserProfession(
                    _prefs, (res.data.user.profession).toString());
                Prefs.setUserPostal(_prefs, (res.data.user.address).toString());

                Prefs.setUserMobile(
                    _prefs, (res.data.user.mobileNo).toString());
                Prefs.setUserCCode(
                    _prefs, (res.data.user.country_code).toString());


                Timer(Duration(seconds: 1),
                        () =>
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder:
                                (context) =>
                                AppLanguagePage(from: "sign-up")
                            ), ModalRoute.withName("/AppLanguage")
                        )
                );
              }
              else {

              }
            });
          }
        }
        /*  Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder:
                (context) =>
                HomePage()
            ), ModalRoute.withName("/HomePage")
        );*/
      /*  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return AppLanguagePage();
                }
            ) );*/

      },

      child: Container(
        width: 150,
        height: ScreenUtil().setWidth(40),
        margin: EdgeInsets.fromLTRB(0,15,0,10),
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
          'NEXT',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




