
import 'dart:io';

import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'VerifyOTP.dart';
import '../Utils/AppColors.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';
import 'DonatedSuccessfuly.dart';

import 'package:shared_preferences/shared_preferences.dart';
//import 'package:device_info/device_info.dart';

import 'DonateUs.dart';
import '../Utils/fab_bottom_app_bar.dart';

import 'HomeChild.dart';
import 'Books.dart';
import 'News.dart';
import 'Quick.dart';
import 'Chat.dart';
import 'ContentLanguage.dart';
import 'VideoApp.dart';
import 'AppLanguage.dart';
import '../localization/language/languages.dart';
import '../Views/MyCart.dart';
import 'package:badges/badges.dart';
class HomePage extends StatefulWidget {
  final int myContentId;
  final String contentType;
  final String invitedBy;
  HomePage({Key key,@required this.myContentId,@required this.contentType,@required this.invitedBy}) : super(key: key);




  @override
  HomePageState createState() => HomePageState(myContentId,contentType,invitedBy);
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver{
  int MyContentId;
  int selectedIndex = 0;

  String mContentType;
  String mInvitedBy="";
  List<Widget> _children;
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  HomePageState(int contentId,String contentType,String invitedBy){
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _children = [
      new HomeChildPage(),
      new NewsPage(),
      new BooksPage(),

    //  new QuickPage(),
     // new ChatPage(),
      //  new SettingsScreen(),
    ];

  }





  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  void onItemTapped(int index) {

    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    var mfontSize=20.0;
    if(Languages.of(context).langCode=='en'){
      mfontSize=24.0;
    }
    else if(Languages.of(context).langCode=='hi'){
      mfontSize=28.0;
    }


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1), //or set color with: Color(0xFF0000FF)
    ));
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 56,
          backgroundColor: Color(AppColors.BaseColor),
          title: Text(Languages
              .of(context)
              .appName, style: GoogleFonts.roboto(fontSize: mfontSize,color: Color(0xFFFFFFFF))),
          actions: <Widget>[

            selectedIndex==0?
            Icon(Icons.search,color: Colors.white,size: 25,):Container(),
            SizedBox(
              width: 7,
            ),
            selectedIndex==0?Icon(Icons.bookmark_outlined,color: Colors.white,size: 25,):Container(),
            SizedBox(
              width: 7,
            ),
            selectedIndex==0? Icon(Icons.notifications_rounded,color: Colors.white,size: 25,):Container(),

            selectedIndex==2?
            GestureDetector(
              onTap: () {

                Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return MyCartPage();
                        }
                    ) );

              },child:
    Badge(
      position: BadgePosition.topEnd(top: 0, end: -4),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
    badgeContent: Text('3',
        style: GoogleFonts.poppins(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w500)),
    child: Icon(Icons.shopping_cart,color: Colors.white,size: 26,),
    ),
            ):Container(),
            selectedIndex==2? SizedBox(
              width: 10,
            ):Container(),
            SizedBox(
              width: 10,
            ),

          ],

        ),
        drawer: navigationDrawer(),
        body: _children[selectedIndex],
        bottomNavigationBar: FABBottomAppBar(
          backgroundColor: Color(AppColors.BaseColor),
          selectedColor:Colors.white,
          onTabSelected: onItemTapped,

          items: [
            FABBottomAppBarItem(iconData: selectedIndex==0?  Image(image: AssetImage('assets/ic_home_sel.png'), width: 24,height: 24,)
                : Image(image: AssetImage('assets/ic_home_unsel.png'), width: 24,height: 24,), text: 'Home'),
            FABBottomAppBarItem(iconData: selectedIndex==1?  Image(image: AssetImage('assets/ic_home_sel.png'), width: 24,height: 24,)
                : Image(image: AssetImage('assets/news_unselected.png'), width: 24,height: 24,), text: 'News'),
            FABBottomAppBarItem(iconData: selectedIndex==2?  Image(image: AssetImage('assets/ic_book_sel.png'), width: 24,height: 24,)
                : Image(image: AssetImage('assets/book_unselected.png'), width: 24,height: 24,), text: 'Books'),

          ],
        ),
      );
    }
  }

class navigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(context),
          createDrawerBodyItem(
              icon: Image(image: AssetImage('assets/about.png'), width: 20,height: 20,),
              text: Languages
                  .of(context)
                  .aboutUs,
              onTap: () =>{}
            // Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          createDrawerBodyItem(
              icon: Image(image: AssetImage('assets/joinus.png'), width: 20,height: 20,),
              text: Languages
                  .of(context)
                  .joinUs,
              onTap: () =>{ /*Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
              MaterialPageRoute(
              builder: (BuildContext context) {
              return DonatedSuccessfulyPage();
              }
              ) )*/}
            // Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          createDrawerBodyItem(
              icon: Image(image: AssetImage('assets/donate.png'), width: 20,height: 20,),
              text: Languages
                  .of(context)
                  .donateUs,
              onTap: () =>{
                /*  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return DonateUsPage();
                        }
                    ) )*/

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
                          return VideoApp();
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
            onTap: () =>{}
               // Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),



          createDrawerBodyItem(
              icon: Image(image: AssetImage('assets/app_language.png'), width: 20,height: 20,),
              text: Languages
                  .of(context)
                  .appLanguage,
              onTap: () =>{
              Navigator.of(context).pop(),
                Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AppLanguagePage(from:"Home");
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
                  .notifications,
              onTap: () =>{}
            // Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          createDrawerBodyItem(
              icon: Image(image: AssetImage('assets/dark.png'), width: 20,height: 20,),
              text: Languages
                  .of(context)
                  .darkMode,
              onTap: () =>{}
            // Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          createDrawerBodyItem(
              icon: Image(image: AssetImage('assets/faq.png'), width: 20,height: 20,),
              text: Languages
                  .of(context)
                  .faq,
              onTap: () =>{}
            // Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          createDrawerBodyItem(
              icon: Image(image: AssetImage('assets/share.png'), width: 20,height: 20,),
              text: Languages
                  .of(context)
                  .shareApp,
              onTap: () =>{}
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
            onTap: () =>{}
                //Navigator.pushReplacementNamed(context, pageRoutes.notification),
          ),
        
        ],
      ),
    );
  }
}
Widget createDrawerBodyItem({Image icon, String text, GestureTapCallback onTap}) {
  bool isSwitchShow=false;
  if(text=='Dark Mode'){
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
Widget createDrawerHeader(BuildContext context) {
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
           Text(
             Languages
                 .of(context)
                 .appName,
                style: TextStyle(
                  fontSize: 20.0,

                  color: Colors.white,
                  fontWeight: FontWeight.w600,

                ),
              ),



      ])));
}


