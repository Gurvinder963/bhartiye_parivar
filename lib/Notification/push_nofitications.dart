import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:intl/intl.dart';

import 'dart:math';
import 'dart:async';
import 'dart:convert';


import '../Interfaces/NewNotificationRecieved.dart';
//import 'package:event_bus/event_bus.dart';
import '../Interfaces/NewNotificationRecieved.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../Interfaces/OnNotificationPayload.dart';
import 'package:flutter/material.dart';
class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  random(min, max){
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }



  Future<void> init(BuildContext context) async {
 //   if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(


          onResume: (Map<String, dynamic> message) {
            print('on resume $message');
            Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
            Future<String> token;
            token = _prefs.then((SharedPreferences prefs) {
             // prefs.setBool('isNewNotification', true);
              //int counter = (prefs.getInt('unReadCount') ?? 0) + 1;

              //print("push_my_unread_count$counter");
              //prefs.setInt('unReadCount', counter);

/*
              Future.delayed(const Duration(milliseconds: 1000), () {
                RxBus.post(NewNotificationRecieved("hello"));

              });*/
              Future.delayed(const Duration(milliseconds: 1000), () {
                eventBusN.fire(NewNotificationRecieved("FIND"));

              });

              int userId=prefs.getInt('userId') ?? 0;


              final DateTime now = DateTime. now();
              final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm');
              final String formatted = formatter. format(now);
              print(formatted); // something like 2013-04-20
            //  print("Message $message");
             print("my-type");
              print(message['data']['type']);
          //    final db = SqliteDB();
              // db.createUserTable();
           //   db.putUser(userId.toString(),message['data']['title'],message['data']['body'],formatted,message['data']['type'],message['data']['id']);
              // _showBigPictureNotification(random(1,5), message['notification']['title'], message['notification']['body'], "");
            //  _showBigTextNotification(random(1,5), message['notification']['title'], message['notification']['body'], message['data']['type']);


              return (prefs.getString('token'));
            });
  //          String type=message['data']['type'];
           // if(type=='rate'){

    //        if(message['data']['type']=='3'){
      //        type=type+","+message['data']['id'];
        //    }
         /*     Future.delayed(const Duration(milliseconds: 1000), () {
                RxBus.post(OnNotificationPayload(type));
              });*/
          //  }
          },
          onLaunch: (Map<String, dynamic> message) async {

            Future.delayed(const Duration(milliseconds: 1000), () {
              eventBusN.fire(NewNotificationRecieved("FIND"));

            });
            //debugPrint("onLaunch foo: " + message['data']['type']);
        /*    print('on launch $message');
            final type = message['data']['type'];
            final id = message['data']['id'];

          if(type=='3') {
              Navigator.of(context, rootNavigator: true)
                  .push(// ensures fullscreen
                  MaterialPageRoute(builder: (BuildContext context) {
                    return QuestionDetailPage(
                      contentID: int.parse(id),
                    );
                  }));
            }
          else if(type=='rate'){*/

          /*  Future.delayed(const Duration(milliseconds: 5000), () {
              RxBus.post(OnNotificationPayload('rate'));
            });*/
         // }
          },

          onMessage: (Map<String, dynamic> message) async {


            Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
            Future<String> token;
            token = _prefs.then((SharedPreferences prefs) {
              //prefs.setBool('isNewNotification', true);
              //int counter = (prefs.getInt('unReadCount') ?? 0) + 1;

              //print("push_my_unread_count$counter");
               //prefs.setInt('unReadCount', counter);


             /* Future.delayed(const Duration(milliseconds: 1000), () {
                RxBus.post(NewNotificationRecieved("hello"));

              });*/
              Future.delayed(const Duration(milliseconds: 1000), () {
                eventBusN.fire(NewNotificationRecieved("FIND"));

              });


              //int userId=prefs.getInt('userId') ?? 0;


              final DateTime now = DateTime. now();
              final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm');
              final String formatted = formatter. format(now);
              print(formatted); // something like 2013-04-20
             // print("Message $message");
              print("on-message");
              print(message);
              print(message['data']['type']);

              String big_image_url=message['data']['big_image_url'];
              String small_image_url=message['data']['small_image_url'];

              print(big_image_url);
              print(small_image_url);

            //  final db = SqliteDB();
              // db.createUserTable();
             // db.putUser(userId.toString(),message['notification']['title'],message['notification']['body'],formatted,message['data']['type'],message['data']['id']);
              // _showBigPictureNotification(random(1,5), message['notification']['title'], message['notification']['body'], "");
              String type=message['data']['type'];
             String msg;
              if(type=='1'){
                msg="New Video Added";
              }

              else if(type=='2'){
                msg="New News Added";
              }
              else if(type=='3'){
                msg="New Book Added";
              }

              if(big_image_url!=null && !big_image_url.toString().isEmpty){
                print("in-big_image-url");
                _showBigPictureNotification(
                    random(1, 5), msg,
                    message['notification']['title'], type,big_image_url,small_image_url);
              }
              else {
                print("in-only-notififaction");

                _showBigTextNotification(
                    random(1, 5), msg,
                    message['notification']['title'], type);
              }

              return (prefs.getString('token'));
            });


        return;
      });


      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fcm_token', token);
      _initialized = true;
  //  }
  }
  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> _showBigPictureNotification( int notificationId,
      String notificationTitle,
      String notificationContent,
      String payload,String bigImageUrl,String smallImageUrl) async {
    final String largeIconPath = await _downloadAndSaveFile(
        smallImageUrl, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        bigImageUrl, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: notificationTitle,
        htmlFormatContentTitle: true,
        summaryText: notificationContent,
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('big text channel id',
        'big text channel name', 'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);



    var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
        notificationId,  notificationTitle,
        notificationContent, platformChannelSpecifics , payload: payload,);
  }
  Future<void> _showBigTextNotification( int notificationId,
      final String notificationTitle,
      final String notificationContent,
      String payload, {
        String channelId = '1234',
        String channelTitle = 'Android Channel',
        String channelDescription = 'Default Android Channel for notifications',

      }) async {

    final String title=notificationTitle;
    final String desc=notificationContent;

     BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      desc,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,

    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);
     AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('big text channel id',
        'big text channel name', 'big text channel description', importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      desc,
      platformChannelSpecifics,
      payload: payload,
    );

  }

  Future<void> _showNotification(
      int notificationId,
      String notificationTitle,
       String notificationContent,
      String payload, {
        String channelId = '1234',
        String channelTitle = 'Android Channel',
        String channelDescription = 'Default Android Channel for notifications',

      }) async {

 /*   const BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      notificationContent,
      htmlFormatBigText: true,
      contentTitle: notificationTitle,
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );*/


    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: false,


    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}