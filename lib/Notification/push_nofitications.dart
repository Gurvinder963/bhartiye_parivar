import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;



import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import '../Utils/Prefer.dart';
import '../Interfaces/NewNotificationRecieved.dart';
//import 'package:event_bus/event_bus.dart';
import '../Interfaces/NewNotificationRecieved.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../Interfaces/OnNotificationPayload.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


 random(min, max){
    var rn = new Random();
    return min + rn.nextInt(max - min);
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
        'big text channel name', 'big text channel description',playSound: true,
        styleInformation: bigPictureStyleInformation);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);



    var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
        notificationId,  notificationTitle,
        notificationContent, platformChannelSpecifics , payload: payload,);
  }
//   void onStart() async{
//   WidgetsFlutterBinding.ensureInitialized();

//    AudioPlayer player = AudioPlayer();
//   await player.setAsset('assets/audio/simple_ring.mp3');
//   player.play();
// }
Future<void> _showBigTextNotification(String content_id,String image_url,String isSound, int notificationId,
      final String notificationTitle,
      final String notificationContent,
      String ntype) async {

//AudioPlayer player = AudioPlayer();
 //var duration = await player.play('https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3');

if(ntype=='4'){

FlutterRingtonePlayer.play(
  android: AndroidSounds.ringtone,
  ios: IosSounds.glass,
  looping: false, // Android only - API >= 28
  volume: 1.0, // Android only - API >= 28
  asAlarm: false, // Android only - all APIs
);

Future.delayed(const Duration(milliseconds: 30000), () {

// Here you can write your code
FlutterRingtonePlayer.stop();


});
}
//FlutterRingtonePlayer.playRingtone();
      //SystemSound.play(SystemSoundType.alert);
//FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
      String chName="";
      String chId="";
       String chDes="";

       if(isSound=='true'){
chName="Noti_with_sound";
chId="Noti_with_id_sound";
chDes="Noti_with_des_sound";
       }
       else{
chName="Noti_with_sound_no";
chId="Noti_with_id_sound_no";
chDes="Noti_with_des_sound_no";
       }

    
     final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;



    final String title=notificationTitle;
    final String desc=notificationContent;

     BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      desc,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,

    );
    // var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);
    //  AndroidNotificationDetails androidPlatformChannelSpecifics =
    // AndroidNotificationDetails(chId,
    //     chName, chDes, importance: Importance.max,
    //     priority: Priority.high,
    //     showWhen: false,
    //     playSound: isSound=='true'?true:false,
    //     sound: isSound=='true'?RawResourceAndroidNotificationSound('bell_in_temple'):null,
    //      vibrationPattern: vibrationPattern,
    //     styleInformation: bigTextStyleInformation,
    //     );
    // var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics);
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //  flutterLocalNotificationsPlugin.show(
    //   notificationId,
    //   title,
    //   desc,
    //   platformChannelSpecifics,
    //   payload: payload,
    // );
    
   if(image_url.isNotEmpty){
AwesomeNotifications().createNotification(
      content: NotificationContent(
      title: title,
      body: desc,
       largeIcon: image_url,
      bigPicture: image_url,
        id: int.parse(content_id),
        
      notificationLayout: NotificationLayout.BigPicture,
        channelKey: 'call_channel',
      ),
        // actionButtons: [
        //     NotificationActionButton(
        //   key: 'accept',
        //   label: 'Accept',
        // ),
        // NotificationActionButton(
        //   key: 'cancel',
        //   label: 'Cancel',
        // ),
        //   ]
    );
   }
   else{
     AwesomeNotifications().createNotification(
      content: NotificationContent(
      title: title,
      body: desc,
      
        id: 1,
        
    
        channelKey: 'call_channel',
      ),
        actionButtons: [
            NotificationActionButton(
          key: 'accept',
          label: 'Accept',
        ),
        NotificationActionButton(
          key: 'cancel',
          label: 'Cancel',
        ),
          ]
    );
   }



  }

  Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {

     print("on-message-back");
              print(message);
  _showBigTextNotification(message['data']['content_id'],message['data']['big_image_url'],message['data']['sound'],
                     random(1, 5), message['data']['Title'],
                     message['data']['bodyText'], message['data']['type']);

  // var big_image_url="https://img.youtube.com/vi/FoK7qvfdhIc/mqdefault.jpg";
    //         var  small_image_url="https://img.youtube.com/vi/FoK7qvfdhIc/mqdefault.jpg";

           
              
              
             //    _showBigPictureNotification(
               //      random(1, 5), message['data']['bodyText'],
                 //    message['data']['Title'], message['data']['type'],big_image_url,small_image_url);

  return Future<void>.value();
}

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

Future bgMsgHdl(Map<String, dynamic> message) async {
  print("onbgMessage: $message");
}

  Future<void> init() async {
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
           onBackgroundMessage: Platform.isAndroid ? backgroundMessageHandler : null,
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


             ///https://img.youtube.com/vi/FoK7qvfdhIc/mqdefault.jpg

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
             String title;
              if(type=='1'){
                msg="New Video Added";
                title=message['data']['title'];
              }

              else if(type=='2'){
                msg="New News Added";
                title=message['data']['title'];
              }
              else if(type=='3'){
                msg="New Book Added";
                title=message['data']['title'];
              }
              else{
                msg="Donation Reminder";
                title=message['data']['body'];
              }

            //  big_image_url="https://img.youtube.com/vi/FoK7qvfdhIc/mqdefault.jpg";
              //small_image_url="https://img.youtube.com/vi/FoK7qvfdhIc/mqdefault.jpg";

          
             

                _showBigTextNotification(message['data']['content_id'],message['data']['big_image_url'],message['data']['sound'],
                    random(1, 5), message['data']['Title'],
                    message['data']['bodyText'], message['data']['type']);
            

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
        'big text channel name', 'big text channel description',playSound: true,
        styleInformation: bigPictureStyleInformation);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);



    var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
        notificationId,  notificationTitle,
        notificationContent, platformChannelSpecifics , payload: payload,);
  }
  Future<void> _showBigTextNotification(String content_id,String image_url,String isSound, int notificationId,
      final String notificationTitle,
      final String notificationContent,
      String nType) async {

// final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
//         await _getByteArrayFromUrl('https://via.placeholder.com/48x48'));
//     final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
//         await _getByteArrayFromUrl('https://via.placeholder.com/400x800'));
 
 //AudioPlayer player = AudioPlayer();
 //var duration = await player.play('https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3');
 
 
 if(nType=='4'){
 
 FlutterRingtonePlayer.play(
  android: AndroidSounds.ringtone,
  ios: IosSounds.glass,
  looping: false, // Android only - API >= 28
  volume: 1.0, // Android only - API >= 28
  asAlarm: false, // Android only - all APIs
);
Future.delayed(const Duration(milliseconds: 30000), () {

// Here you can write your code
FlutterRingtonePlayer.stop();


});
 }
//SystemSound.play(SystemSoundType.alert);
//FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
      String chName="";
      String chId="";
       String chDes="";

       if(isSound=='true'){
chName="Noti_with_sound";
chId="Noti_with_id_sound";
chDes="Noti_with_des_sound";
       }
       else{
chName="Noti_with_sound_no";
chId="Noti_with_id_sound_no";
chDes="Noti_with_des_sound_no";
       }

    
     final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;


 const int insistentFlag = 4;
    final String title=notificationTitle;
    final String desc=notificationContent;





     BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      desc,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,

    );
    // var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);
    //  AndroidNotificationDetails androidPlatformChannelSpecifics =
    // AndroidNotificationDetails(chId,
    //     chName, chDes, importance: Importance.max,
    //     priority: Priority.high,
    //     showWhen: false,
    //     playSound: isSound=='true'?true:false,
    //     sound: isSound=='true'?RawResourceAndroidNotificationSound('bell_in_temple'):null,
    //      vibrationPattern: vibrationPattern,
    //     styleInformation: bigTextStyleInformation,
    //     );
    // var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics);
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //  flutterLocalNotificationsPlugin.show(
    //   notificationId,
    //   title,
    //   desc,
    //   platformChannelSpecifics,
    //   payload: payload,
    // );
    
  if(image_url.isNotEmpty){

  AwesomeNotifications().createNotification(
      content: NotificationContent(
      title: title,
      body: desc,
       largeIcon: image_url,
      bigPicture: image_url,
        id: int.parse(content_id),
        
      notificationLayout: NotificationLayout.BigPicture,
        channelKey: 'call_channel',
      ),
        // actionButtons: [
        //     NotificationActionButton(
        //   key: 'accept',
        //   label: 'Accept',
        // ),
        // NotificationActionButton(
        //   key: 'cancel',
        //   label: 'Cancel',
        // ),
        //   ]
    );
  }
  else{

  AwesomeNotifications().createNotification(
      content: NotificationContent(
      title: title,
      body: desc,
   
        id: 1,
        
   
        channelKey: 'call_channel',
      ),
        actionButtons: [
            NotificationActionButton(
          key: 'accept',
          label: 'Accept',
        ),
        NotificationActionButton(
          key: 'cancel',
          label: 'Cancel',
        ),
          ]
    );

  }

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