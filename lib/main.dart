import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/constants.dart';
import 'Views/Login.dart';
import 'Utils/Prefer.dart';
import 'Views/Home.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /*if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
   debugPrint("didNotificationLauchAPP");
    Future.delayed(const Duration(milliseconds: 5000), () {
      RxBus.post(OnNotificationPayload(notificationAppLaunchDetails.payload));
    });
  }*/
  // Crashlytics.instance.enableInDevMode = true;


  // Pass all uncaught errors from the framework to Crashlytics.

  // Pass all uncaught errors from the framework to Crashlytics.
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;


  runApp(MyApp());
}

class MyApp extends StatelessWidget {



  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      title: Constants.AppName,
      theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          )
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  int deepLinkContentId=-1;
  String contentType="";
  @override
  _MyHomePageState createState() => _MyHomePageState(deepLinkContentId,contentType);
}
class _MyHomePageState extends State<MyHomePage> {

  int mDeepLinkContentId=-1;
  String mContentType="";
  String mInvitedBy="";
  _MyHomePageState(int deepLinkContentId,String contentType){
    mDeepLinkContentId=deepLinkContentId;
    mContentType=contentType;
  }


  @override
  void initState() {
    super.initState();


    mDeepLinkContentId=-1;
    mContentType="";




    Future<SharedPreferences> _prefs;
    var initializationSettingsAndroid =





   _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {
      print(prefs.getString('token'));
      String tok=prefs.getString(Prefs.KEY_TOKEN);
      int classId=prefs.getInt('ClassId') ?? 0;
      if(tok==null){
        Timer(Duration(seconds: 2),
                ()=>Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder:
                    (context) =>
                        LoginPage()
                ), ModalRoute.withName("/Login")
            )
        );
      }


      else {
       Timer(Duration(seconds: 5),
                ()=> Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return HomePage();
                        }
                    )
            )
        );
      }

      return (prefs.getString('token'));
    });


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.fromLTRB(30,30,30,30),
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFffffff),
              const Color(0xFFffffff),
              const Color(0xFFffffff),

            ],
          ),
         ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[



              new Image(
                image: new AssetImage("assets/splash.png"),

                color: null,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ),

            ])

    );
  }
}
