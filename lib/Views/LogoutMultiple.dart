import 'dart:convert';

import 'package:bhartiye_parivar/ApiResponses/LogoutResponse.dart';
import 'package:bhartiye_parivar/Repository/MainRepository.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'Login.dart';

class LogoutMultiplePage extends StatefulWidget {
  final String logoutMessage;

  LogoutMultiplePage({Key key,@required this.logoutMessage,}) : super(key: key);


  @override
  LogoutMultiplePageState createState() {
    return LogoutMultiplePageState(logoutMessage);
  }
}

class LogoutMultiplePageState extends State<LogoutMultiplePage> {
  String logoutMessage;

  String user_Token;

  String USER_ID;
  LogoutMultiplePageState(String logoutMessage){

    this.logoutMessage=logoutMessage;
  }

  @override
  void initState() {
    super.initState();


    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID= prefs.getString(Prefs.USER_ID);

      return (prefs.getString('token'));
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Color(AppColors.BaseColor),
          title: Text("Logout", style: GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 23,color: Color(0xFFFFFFFF))),

        ),
      body:Container(
        color: Colors.grey,
        child: Center(child:Container(child:
    Column (

        children: <Widget> [
          _thisDeviceButton(),
          _allDeviceButton(),
          _cancelDeviceButton()

        ]))),

    ));
  }
  Future<LogoutResponse> callLogoutAPI(String type,String userid,String token) async {

    var body =json.encode({'logouttype':type,'userid':userid,"appcode":Constants.AppCode,"token":token,});

    //var body ={'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,"name":name,"phone":mobile,"pincode":pincode};
    MainRepository repository=new MainRepository();
    return repository.fetchLogoutJava(body);

  }
  removeFromSF(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();


    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(from: "splash")),
        ModalRoute.withName("/Login"));
  }
  showAlertDialogValidation(BuildContext context,String message,String userId,String token,String logoutmessage,int type) {

    print(userId);
    String res;
    if(type==1){

      res="thisapp";
    }
    else{
      res="allapp";
    }

    Widget SingleButton =  InkWell(
      onTap: () {
        callLogoutAPI(res,userId,token).then((value) async {
          if(value.status==1){
            Navigator.of(context, rootNavigator: true).pop('dialog');
            removeFromSF(context);
          }

        });
      },

      child: Container(
        width: 100,
        margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
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
                colors: [
                  Color(0xFFD8D8D8),
                  Color(0xFFD8D8D8)
                ])),
        child: Text(
          'Yes',
          style: GoogleFonts.poppins(

              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );


    // Widget SingleButton = FlatButton(
    //   child: Text("This App"),
    //   onPressed: () {
    //     callLogoutAPI("thisapp",userId,token).then((value) async {
    //       if(value.status==1){
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //         removeFromSF(context);
    //       }
    //
    //     });
    //   },
    // );

    Widget CancelButton =  InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },

      child: Container(
        width: 100,
        margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
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
                colors: [
                  Color(AppColors.BaseColor),
                  Color(AppColors.BaseColor)
                ])),
        child: Text(
          'No',
          style: GoogleFonts.poppins(

              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );


    // Widget BothButton = FlatButton(
    //   child: Text("All Apps"),
    //   onPressed: () {
    //    // Navigator.of(context, rootNavigator: true).pop('dialog');
    //     callLogoutAPI("allapp",userId,token).then((value) async {
    //        if(value.status==1){
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //         removeFromSF(context);
    //        }
    //
    //     });
    //
    //   },
    // );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Constants.AppName),
      content: Text(message),
      actions: [
        SingleButton,
        //logoutmessage=="multiple app"?BothButton:null,
        CancelButton,
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

  Widget _thisDeviceButton() {
    return InkWell(
      onTap: () {
        showAlertDialogValidation(context,
            "Are you sure you want to logout from this device?",
            USER_ID, user_Token, logoutMessage,1);

      },
      child: Container(
        width: 280,
        height: ScreenUtil().setWidth(40),
        margin: EdgeInsets.fromLTRB(0, 100, 0, 10),
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
                colors: [
                  Colors.white,
                  Colors.white
                ])),
        child: Text(
          'Logout from this device only',
          style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(16),
              color: Colors.black,
             ),
        ),
      ),
    );
  }
  Widget _allDeviceButton() {
    return InkWell(
      onTap: () {
        showAlertDialogValidation(context,
            "Are you sure you want to logout from all devices?",
            USER_ID, user_Token, logoutMessage,2);

      },
      child: Container(
        width: 280,
        height: ScreenUtil().setWidth(40),
        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                colors: [
                  Colors.white,
                  Colors.white
                ])),
        child: Text(
          'Logout from all device',
          style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(16),
              color: Colors.black,
              ),
        ),
      ),
    );
  }
  Widget _cancelDeviceButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop(context);

      },
      child: Container(
        width: 280,
        height: ScreenUtil().setWidth(40),
        margin: EdgeInsets.fromLTRB(0,20, 0, 10),
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
                colors: [
                  Color(AppColors.BaseColor),
                  Color(AppColors.BaseColor)
                ])),
        child: Text(
          'Cancel',
          style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(18),
              color: Colors.white,
           ),
        ),
      ),
    );
  }



}