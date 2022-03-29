import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/constants.dart';
import 'Views/Login.dart';
import 'Utils/Prefer.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'Views/Home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Notification/push_nofitications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'Interfaces/OnDeepLinkContent.dart';
import 'package:provider/provider.dart';
import 'Interfaces/FullScreenChangeListner.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

   PushNotificationsManager pfg =new PushNotificationsManager();
    pfg.init();
  NotificationAppLaunchDetails notificationAppLaunchDetails;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  
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


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
   // runApp(new MyApp());
   runApp(
    ChangeNotifierProvider(
      create: (context) => FullScreenChangeListner(),
      child: MyApp(),
    ),
  );
  });
}
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}
class MyApp extends StatefulWidget  {

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }
  @override
  State<StatefulWidget> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {


  Locale _locale;
  @override
  void initState() {
    super.initState();
   

AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://mipmap/ic_ic_launcher',
    [
        NotificationChannel(
            channelKey: 'call_channel',
            channelName: 'Call notifications',
            channelDescription: 'Notification channel for call tests',
            defaultColor: Color(0xFFFFA500),
            ledColor: Colors.white,
            locked: true,
          importance: NotificationImportance.High,
          vibrationPattern: highVibrationPattern,
        )
    ]
);
AwesomeNotifications().actionStream.listen((event) {
        FlutterRingtonePlayer.stop();
        print(event.buttonKeyInput);

      if (event.buttonKeyInput == 'cancel') {
        print("on cancel clicked");
      } 
      
      else if (event.buttonKeyInput == 'accept') {
        print("on accept clicked");
      }
      else {
       print("notification click bg killed");
      }
    });



    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: ' + payload);

            //   if(payload=='rate'){

          /*  Future.delayed(const Duration(milliseconds: 1000), () {
              RxBus.post(OnNotificationPayload(payload));
            });*/
            //  }
          }
          //  selectNotificationSubject.add(payload);
        });
  }
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: Constants.AppName,
      theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(
            Theme
                .of(context)
                .textTheme,
          )
      ),
      locale: _locale,
      home: MyHomePage(),
      supportedLocales: [
        Locale('en', ''),
        Locale('hi', '')
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale?.languageCode == locale?.languageCode &&
              supportedLocale?.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales?.first;
      },
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
    initDynamicLinks();



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
                        LoginPage(from: "splash")
                ), ModalRoute.withName("/Login")
            )
        );
      }


      else {
        Timer(Duration(seconds: 2),
                ()=>Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder:
                    (context) =>
                    HomePage()
                ), ModalRoute.withName("/Home")
            )
        );
      }

      return (prefs.getString('token'));
    });


  }
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          print("in deep link method2");
          if (deepLink != null) {
            //  Navigator.pushNamed(context, deepLink.path);
            print("deep_link_path"+deepLink.path);
            var isContent=deepLink.pathSegments.contains('content');
            var invitedby=deepLink.pathSegments.contains('invitedby');

            if(invitedby){
              var id=deepLink.queryParameters['referral_code'];
              print("invited_id"+id);
              mInvitedBy=id;
           //   RxBus.post(OnDeepLinkReferel(mInvitedBy));
            }
            if(isContent){

              var id=deepLink.queryParameters['contentId'];
              var contentType=deepLink.queryParameters['contentType'];
             // var referId=deepLink.queryParameters['referral_code'];
              //mInvitedBy=referId;
            //  RxBus.post(OnDeepLinkReferel(mInvitedBy));
              print(contentType);
              Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
              Future<String> token;
              token = _prefs.then((SharedPreferences prefs) {
                print(prefs.getString('TOKEN'));
                var tok=prefs.getString('TOKEN');

                if(tok==null){
                 print("On--token--null");
                }

                else {
                  Future.delayed(const Duration(milliseconds: 500), () {
                   // eventBusDL.fire(int.parse(id),contentType));
                    print("On--fire");
                    eventBusDL.fire(OnDeepLinkContent(int.parse(id),contentType));
                   // RxBus.post(OnDeepLinkContent(int.parse(id),contentType));
                  });
                }

                return (prefs.getString('TOKEN'));
              });

            }
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    print("in deep link method1");
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print("deep_link_path"+deepLink.path);
      var isContent=deepLink.pathSegments.contains('content');
      var invitedby=deepLink.pathSegments.contains('invitedby');

      if(invitedby){
        var id=deepLink.queryParameters['referral_code'];
        print("invited_id"+id);
        mInvitedBy=id;
      }


      if(isContent){

        var id=deepLink.queryParameters['contentId'];
        var contentType=deepLink.queryParameters['contentType'];
       // var referId=deepLink.queryParameters['referral_code'];
      //  mInvitedBy=referId;
        mContentType=contentType;
        print(contentType);
        mDeepLinkContentId=int.parse(id);
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        Future<String> token;
        token = _prefs.then((SharedPreferences prefs) {
          print(prefs.getString('TOKEN'));
          var tok=prefs.getString('TOKEN');

          if(tok==null){

          }

          else {

         Timer(Duration(seconds: 4),
                    ()=>  eventBusDL.fire(OnDeepLinkContent(int.parse(id),contentType))
            );



          }

          return (prefs.getString('TOKEN'));
        });

      }
      else{

      }


      // Navigator.pushNamed(context, deepLink.path);
    }
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
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),

            ])

    );
  }
}
