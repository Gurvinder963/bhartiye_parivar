
import 'dart:io';
import 'package:bhartiye_parivar/ApiResponses/SideBarApiResponse.dart';
import 'package:bhartiye_parivar/Views/AdminPanel.dart';
import 'package:bhartiye_parivar/Views/EditProfile.dart';
import 'package:bhartiye_parivar/Views/LogoutMultiple.dart';
import 'package:bhartiye_parivar/Views/terms.dart';
import 'package:intl/intl.dart';
import 'package:bhartiye_parivar/Interfaces/NewNotificationRecieved.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'NotificationSetting.dart';
import 'VerifyOTP.dart';
import '../Utils/AppColors.dart';
import '../Views/Login.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:event_bus/event_bus.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';
import '../Views/CreateProfile.dart';
import 'package:flutter/services.dart';
import 'DonatedSuccessfuly.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
//import 'package:device_info/device_info.dart';
import '../Views/YoutubeApp.dart';
import 'DonateUs.dart';
import '../Utils/fab_bottom_app_bar.dart';

import 'HomeChild.dart';
import '../ApiResponses/OTPResponse.dart';
import 'Books.dart';
import 'NewsMain.dart';
import 'Share.dart';
import 'Quick.dart';
import 'Chat.dart';
import 'ContentLanguage.dart';
import 'VideoApp.dart';
import 'AppLanguageInner.dart';
import '../localization/language/languages.dart';
import '../Views/MyCart.dart';
import 'package:badges/badges.dart';
import '../Repository/MainRepository.dart';
import '../ApiResponses/HomeAPIResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../Interfaces/OnCartCount.dart';
import '../Interfaces/OnNewsBack.dart';
import '../Interfaces/OnDeepLinkContent.dart';
import '../Views/BookmarkList.dart';
import '../Views/SearchScreen.dart';
import '../Views/NotificationList.dart';
import '../Views/DonationReminder.dart';
import 'VideoDetailNew.dart';
import '../ApiResponses/VideoData.dart';
import '../ApiResponses/VideoDetailResponse.dart';
import '../Views/JoinUs.dart';
import '../ApiResponses/NewsDetailResponse.dart';
import '../ApiResponses/LogoutResponse.dart';
import '../Interfaces/NewNotificationRecieved.dart';
import '../Interfaces/OnAnyDrawerItemOpen.dart';
import 'NewsDetail.dart';
import '../Views/Faq.dart';



class MyDrawerPage extends StatefulWidget {
  @override
  MyDrawerPageState createState() {
    return MyDrawerPageState();
  }
}

class MyDrawerPageState extends State<MyDrawerPage> {
  bool _isInAsyncCall = false;
  String user_Token;
  String USER_NAME="";
  String USER_ID="";
  bool isNotification;
  bool isSound;
  String logoutMessage="";
  String sideBarOTP="No OTP";

  String url1;
  Future<SideBarApiResponse> callSideBarAPI(String userid,String token) async {

    var body =json.encode({'userid':userid,"appcode":Constants.AppCode,"token":token,});

    //var body ={'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,"name":name,"phone":mobile,"pincode":pincode};
    MainRepository repository=new MainRepository();
    return repository.fetchSidebarApI(body);

  }



  @override
  void initState() {
    super.initState();
    eventBusDO.fire(OnAnyDrawerItemOpen("FIND"));
    isNotification=false;
    isSound=false;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_NAME=prefs.getString(Prefs.USER_NAME);
      USER_ID=prefs.getString(Prefs.USER_ID);

       url1="https://sabkiapp.com:8443/Admin/Admin_login_app_Action.jsp?appcode="+Constants.AppCode+"&userid="+USER_ID+"&token="+user_Token;
      callLogoutAPI("check",USER_ID,user_Token).then((value) async {
        if(value.status==1){


          setState(() {
            logoutMessage=value.msg;
          });


        }

      });



      callSideBarAPI(USER_ID,user_Token).then((value) async {
        if(value.status==1){

          setState(() {
            sideBarOTP=value.sideBarOTP;
          });


        }

      });
      return (prefs.getString('token'));
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Drawer(

          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              createDrawerHeader(context,sideBarOTP),

              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/ic_admin_new.jpg'), width: 22,height: 22,),
                  text: Languages
                      .of(context)
                      .adminPanel,
                  onTap: () =>{



                    Navigator.of(context, rootNavigator: true)
                        .push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AdminPanelPage(link:url1,name:"Admin Page");
                            }
                        ))

                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),

              Padding(
                  padding: EdgeInsets.fromLTRB(15,0,15,0),
                  child:
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.orange,
                  )),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/about.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .aboutUs,
                  onTap: () =>{

                    Navigator.of(context, rootNavigator: true)
                        .push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return JoinUsPage();
                            }
                        ))
                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/joinus.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .joinUs,
                  onTap: () =>
                  {

                    Navigator.of(context, rootNavigator: true)
                        .push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return JoinUsPage();
                            }
                        ))
                  }

                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/donate.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .donateUs,
                  onTap: () =>{

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DonateUsPage();
                            }
                        ) )

                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/contactus.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .contactUs,
                  onTap: () =>{

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DonationReminderPage();
                            }
                        ) )


                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.contact),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15,0,15,0),
                  child:
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.orange,
                  )),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/profile.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .profile,
                  onTap: () =>{

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return EditProfilePage();
                            }
                        ) )

                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),



              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/app_language.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .appLanguage,
                  onTap: () =>{

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AppLanguageInnerPage(from:"Home");
                            }
                        ) )

                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/content.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .contentLanguage,
                  onTap: () =>{
                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ContentLanguagePage();
                            }
                        ) )


                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/notifications.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .notificationsSetting,
                  onTap: () =>{

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return NotificationSettingPage();
                            }
                        ) )



                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),
              // createDrawerBodyItem(
              //     icon: Image(image: AssetImage('assets/dark.png'), width: 20,height: 20,),
              //     text: Languages
              //         .of(context)
              //         .darkMode,
              //     onTap: () =>{}
              //   // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              // ),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/faq.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .faq,
                  onTap: () =>{
                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return FaqPage();
                            }
                        ) )


                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/share.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .shareApp,
                  onTap: () =>{

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SharePage();
                            }
                        ) )

                  }
                // Navigator.pushReplacementNamed(context, pageRoutes.profile),
              ),

              Padding(
                  padding: EdgeInsets.fromLTRB(15,0,15,0),
                  child:
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.orange,
                  )),
              createDrawerBodyItem(
                  icon: Image(image: AssetImage('assets/advertise.png'), width: 20,height: 20,),
                  text: Languages
                      .of(context)
                      .termsndPrivacy,
                  onTap: () =>{
                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return TermScreen();
                            }
                        ) )

                  }
                //Navigator.pushReplacementNamed(context, pageRoutes.notification),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0,0,15,0),
                  child:

                  createDrawerBodyItem(
                      icon: Image(image: AssetImage('assets/ic_logout.png'), width: 20,height: 20,),
                      text: Languages
                          .of(context)
                          .logout,
                      onTap: () =>{

                        if(logoutMessage=="multiple app"){
                          Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return LogoutMultiplePage( logoutMessage: logoutMessage,);
                                  }
                              ) )
                        }
                        else
                          {
                            showAlertDialogValidation(context,
                                "Are you sure you want to logout from this device?",
                                USER_ID, user_Token, logoutMessage),
                          }
                      }
                    //Navigator.pushReplacementNamed(context, pageRoutes.notification),
                  ) ),
            ],
          ),
        );

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
  showAlertDialogValidation(BuildContext context,String message,String userId,String token,String logoutmessage) {

    print(userId);

    Widget SingleButton =  InkWell(
      onTap: () {
        callLogoutAPI("thisapp",userId,token).then((value) async {
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
      content: Container(
        height: 130,
        child:
        Column( children: <Widget>[Text(message),
          SizedBox(height: 20,),
          Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                SingleButton,
                SizedBox(width: 20,),
                //logoutmessage=="multiple app"?BothButton:null,
                CancelButton, // button 2
              ]
          )
        ])),
      // actions: [
      //   SingleButton,
      //   //logoutmessage=="multiple app"?BothButton:null,
      //   CancelButton,
      // ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Widget createDrawerBodyItem({Image icon, String text, GestureTapCallback onTap}) {
    bool isSwitchShow=false;
    if(text=='Dark Mode' || text=='डार्क मोड'){
      isSwitchShow=true;
    }


    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      title: Row(
        children: <Widget>[
          icon,
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(text),
          )
          ,isSwitchShow?Expanded(child:Align(
            alignment: Alignment.centerRight,
            child: Switch(
              value: true,
              onChanged: (value) {

              },
              activeTrackColor: Colors.grey,
              activeColor: Colors.orange,
            ),
          )):Container()


        ],
      ),
      onTap: onTap,
    );
  }
  Widget createDrawerHeader(BuildContext context,String sideBarOTP) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,

        child: Container(
            color: Colors.orange,
            child:
            Column( children: <Widget>[
              SizedBox(height: 20),
              new Image(
                image: new AssetImage("assets/splash.png"),
                width: 100,
                height:  100,
                color: null,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ),
              SizedBox(height: 5),
              Text(sideBarOTP=='No OTP'?Languages.of(context).appName:sideBarOTP,
                style: TextStyle(
                  fontSize: 20.0,

                  color: Colors.white,
                  fontWeight: FontWeight.w600,

                ),
              ),



            ])));
  }


}