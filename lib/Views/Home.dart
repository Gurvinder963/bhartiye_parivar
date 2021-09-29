
import 'dart:io';

import 'package:bhartiye_parivar/Interfaces/NewNotificationRecieved.dart';
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
import 'package:event_bus/event_bus.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';
import 'DonatedSuccessfuly.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
//import 'package:device_info/device_info.dart';

import 'DonateUs.dart';
import '../Utils/fab_bottom_app_bar.dart';

import 'HomeChild.dart';
import 'Books.dart';
import 'NewsMain.dart';
import 'Quick.dart';
import 'Chat.dart';
import 'ContentLanguage.dart';
import 'VideoApp.dart';
import 'AppLanguage.dart';
import '../localization/language/languages.dart';
import '../Views/MyCart.dart';
import 'package:badges/badges.dart';
import '../Repository/MainRepository.dart';
import '../ApiResponses/HomeAPIResponse.dart';
import '../Interfaces/OnCartCount.dart';
import '../Interfaces/OnNewsBack.dart';
import '../Views/BookmarkList.dart';
import '../Views/SearchScreen.dart';
import '../Views/NotificationList.dart';

import '../Interfaces/NewNotificationRecieved.dart';
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
  String cartCount='0';
  String mContentType;
  String mInvitedBy="";
  List<Widget> _children;
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool isNewNotification=false;
  bool _isHidden = true;

  String user_Token;
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setCartCount();
    }
  }

  setCartCount() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      var user_Token=prefs.getString(Prefs.KEY_TOKEN);
      cartCount=prefs.getString(Prefs.CART_COUNT);
      setState(() {});

        setState(() {
          cartCount = cartCount;
        });


      return (prefs.getString('token'));
    });

  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _children = [
      new HomeChildPage(),
      new NewsMainPage(),
      new BooksPage(),

    //  new QuickPage(),
     // new ChatPage(),
      //  new SettingsScreen(),
    ];

    eventBus1.on<OnNewsBack>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      // print("my_cart_count"+event.count);

      print("news back fired");
      setState(() {
        selectedIndex = 0;
      });

      //FABBottomAppBarState fABBottomAppBarState=new FABBottomAppBarState();
     // fABBottomAppBarState.updateIndexByNews(0);

    });
    eventBusN.on<NewNotificationRecieved>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      // print("my_cart_count"+event.count);
      print("not_home_api_called");
      homeAPICall();
    });
   // EventBus eventBus = EventBus();
    eventBus.on<OnCartCount>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
     // print("my_cart_count"+event.count);
      homeAPICall();
    });
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);




      homeAPICall();

      return (prefs.getString('token'));
    });
  }

  void homeAPICall(){
    getHOMEAPI(user_Token).then((res) async {

      if(res.status==1) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();


        Prefs.setCartCount(_prefs, (res.data.cartCount).toString());
        setState(() {
          cartCount=res.data.cartCount.toString();
          isNewNotification=res.data.notification;
        });

      }
    });
  }

  Future<HomeAPIResponse> getHOMEAPI(String user_Token) async {

    var body ={'none':'none'};
    MainRepository repository=new MainRepository();
    return repository.fetchHomeData(body,user_Token);

  }



  void onItemTapped(int index) {

    setState(() {
      selectedIndex = index;
    });
  }
  void showDialogCart(){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),

             Text("Are you sure you want to\n close application?"),
             Row(
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);

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
                    'Yes',
                    style: GoogleFonts.poppins(

                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),


              InkWell(
                onTap: () {
                  Navigator.pop(context);

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
              )]),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  onBackNews(){
    eventBus1.fire(OnNewsBack("FIND"));
  }
  @override
  Widget build(BuildContext context) {

    var tit=selectedIndex==0?Languages
        .of(context)
        .appName:"Books";

    var shouldShowBadge=int.parse(cartCount)>0?true:false;
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
      return  WillPopScope(
        child:Scaffold(
        appBar:selectedIndex==1?null: AppBar(
          elevation: 0,
          toolbarHeight: 56,
          backgroundColor: Color(AppColors.BaseColor),
          title: Text(tit, style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),

          actions: <Widget>[

            selectedIndex==0?
            GestureDetector(
                onTap: () {

                  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SearchScreenPage();
                          }
                      ) );

                },child: Icon(Icons.search,color: Colors.white,size: 25,)):Container(),
            SizedBox(
              width: 7,
            ),
            selectedIndex==0? GestureDetector(
    onTap: () {

      Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
          MaterialPageRoute(
              builder: (BuildContext context) {
                return BookmarkListPage();
              }
          ) );

    },child:
    Icon(Icons.bookmark_outlined,color: Colors.white,size: 25,)):Container(),
            SizedBox(
              width: 7,
            ),
            selectedIndex==0?  GestureDetector(
    onTap: () {

      setState(() {
        isNewNotification = false;
      });

      Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
          MaterialPageRoute(
              builder: (BuildContext context) {
                return NotificationListPage();
              }
          ) );


    },child: isNewNotification?Image(
              image: new AssetImage("assets/ic_not_bell.png"),

              height:  20,
              width:  22,


              alignment: Alignment.center,
            ):Icon(Icons.notifications_rounded,color: Colors.white,size: 25,)):Container(),

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
      showBadge: shouldShowBadge,
      position: BadgePosition.topEnd(top: 0, end: -4),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
    badgeContent: Text(cartCount,
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
        bottomNavigationBar: selectedIndex==1?null:FABBottomAppBar(
          backgroundColor: Color(AppColors.BaseColor),
          selectedColor:Colors.white,
          onTabSelected: onItemTapped,

          items: [
            FABBottomAppBarItem(iconData: selectedIndex==0?  Image(image: AssetImage('assets/ic_home_sel.png'), width: 28,height: 28,)
                : Image(image: AssetImage('assets/ic_home_unsel.png'), width: 28,height: 28,), text: Text(
              'Home',
              style: GoogleFonts.roboto(color: selectedIndex==0? Colors.white:Colors.black,fontSize: 12,),
            )),
            FABBottomAppBarItem(iconData: selectedIndex==1?  Image(image: AssetImage('assets/ic_home_sel.png'), width: 28,height: 28,)
                : Image(image: AssetImage('assets/news_unselected.png'), width: 28,height: 28,), text: Text(
              'News',
              style: GoogleFonts.roboto(color: selectedIndex==1? Colors.white:Colors.black,fontSize: 12,),
            )),
            FABBottomAppBarItem(iconData: selectedIndex==2?  Image(image: AssetImage('assets/ic_book_sel.png'), width: 28,height: 28,)
                : Image(image: AssetImage('assets/book_unselected.png'), width: 28,height: 28,), text: Text(
              'Books',
              style: GoogleFonts.roboto(color: selectedIndex==2? Colors.white:Colors.black,fontSize: 12,),
            )),

          ],
        ),
      ),
          onWillPop: () => selectedIndex==1? onBackNews():showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),

                    Text("Are you sure you want to\n close application?",
                      textAlign: TextAlign.center,),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, true);

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
                          ),

                          SizedBox(
                            width: 20,
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);

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
                          )]),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),);
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
              icon: Image(image: AssetImage('assets/about.png'), width: 20,height: 20,color: Colors.black,),
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


