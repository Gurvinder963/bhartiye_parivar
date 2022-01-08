import 'dart:convert';

import 'package:bhartiye_parivar/ApiResponses/AddToCartResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/SideBarApiResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Repository/MainRepository.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';

class NotificationSettingPage extends StatefulWidget {
  @override
  NotificationSettingPageState createState() {
    return NotificationSettingPageState();
  }
}

class NotificationSettingPageState extends State<NotificationSettingPage> {
  bool _isInAsyncCall = false;
  String user_Token;
  String USER_NAME="";
  String USER_ID="";
  bool isNotification;
  bool isSound;
  Future<SideBarApiResponse> callSideBarAPI(String userid,String token) async {

    var body =json.encode({'userid':userid,"appcode":Constants.AppCode,"token":token,});

    //var body ={'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,"name":name,"phone":mobile,"pincode":pincode};
    MainRepository repository=new MainRepository();
    return repository.fetchSidebarApI(body);

  }

  Future<AddToCartResponse> saveNotificationSetting(btnStatus) async {

    var body =json.encode({"buttonstatus":btnStatus,'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,});

    //var body ={'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,"name":name,"phone":mobile,"pincode":pincode};
    MainRepository repository=new MainRepository();
    return repository.fetchNotificationSettingButton(body);

  }

  @override
  void initState() {
    super.initState();
    isNotification=false;
    isSound=false;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_NAME=prefs.getString(Prefs.USER_NAME);
      USER_ID=prefs.getString(Prefs.USER_ID);
      callSideBarAPI(USER_ID,user_Token).then((value) async {
        if(value.status==1){

          setState(() {
            isNotification=value.notificationButtonStatus=='on'?true:false;
          });


        }

      });
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
                  value: isNotification,
                  onChanged: (value) {
                   print(value);

                    setState(() {
                      isNotification = value;
                    });

                    String btnStatus="";
                    if(value){
                      btnStatus="seton";
                    }
                    else{
                      btnStatus="setoff";
                    }


                    saveNotificationSetting(btnStatus).then((res) async {
                     });

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
                value: isSound,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    isSound = value;
                  });


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