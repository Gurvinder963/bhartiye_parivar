import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
class DonatedSuccessfulyPage extends StatefulWidget {
  @override
  DonatedSuccessfulyPageState createState() {
    return DonatedSuccessfulyPageState();
  }
}


class DonatedSuccessfulyPageState extends State<DonatedSuccessfulyPage> {


  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.


    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('mipmap/ic_launcher');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {

        });
    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
     flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }

        });
    _requestPermissions();

  }
  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future<void> _repeatNotification(DateTime dateTime) async {
    print("method_calll");
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating channel id',
        'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true);


  /*   flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime(tz.local, dateTime.year, dateTime.month, dateTime.hour,
          dateTime.minute),
       platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
*/

  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('Donated Successfuly'),
      ),
      body:   Container(
          width: double.infinity ,
          height: height,
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,


              children: [
                SizedBox(height: 20),
                new Image(
                  image: new AssetImage("assets/green_tick_pay.png"),
                  width: 120,
                  height:  120,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),







Row(

    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        Card( elevation: 2,
            margin: EdgeInsets.fromLTRB(10,40,10,10),

          color: Color(0xFFefefef),
                          child:
                          Padding(
                            padding: EdgeInsets.fromLTRB(5,5,5,5),
                            child:  Text("Amount : 100/-",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                          ),
        )
                         , Card( elevation: 2,
                            margin: EdgeInsets.fromLTRB(10,40,10,10),

        color: Color(0xFFefefef),
                            child:
                            Padding(
                              padding: EdgeInsets.fromLTRB(5,5,5,5),
                              child:  Text("Date : 23-05-2021",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                            ),
                          )
                        ])

,
                Card( elevation: 2,
                  margin: EdgeInsets.fromLTRB(30,40,30,10),

                  color: Color(0xFFefefef),
                  child:
                  Padding(
                    padding: EdgeInsets.fromLTRB(20,10,20,10),
                    child:  Text(AppStrings.fillcharmsg,textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,color: Colors.black)),
                  ),
                ),
          Expanded(
              child:
          Align(
                          alignment: Alignment.bottomCenter,
                          child:  SizedBox(
                            width: double.infinity,
                            child:FlatButton(

                              color: Colors.orange,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(12.0),
                              onPressed: ()
                                async {
                                  await  _repeatNotification(DateTime.now());
                                },

                              child: Text(
                                "Done".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        )),


              ])

      ),

    );
  }


}