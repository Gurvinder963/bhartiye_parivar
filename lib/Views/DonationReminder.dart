import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
class DonationReminderPage extends StatefulWidget {
  @override
  DonationReminderPageState createState() {
    return DonationReminderPageState();
  }
}

class DonationReminderPageState extends State<DonationReminderPage> {

  Future<void> scheduleNotification(int count) async {
    tz.initializeDatabase([]);
    var scheduledNotificationDateTime =
    DateTime(2021,10,11,1,17,0); //Here you can set your custom Date&Time


    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    print("formateed--"+formatted);
    BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      'scheduled body',
      htmlFormatBigText: true,
      contentTitle: 'scheduled title',
      htmlFormatContentTitle: true,

    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();



    DateTime newDate = new DateTime(now.year, now.month, now.day+count,now.hour,now.minute-1);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('big text channel id',
        'big text channel name', 'big text channel description', importance: Importance.max,
        priority: Priority.high,
        when: newDate.millisecondsSinceEpoch);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
        0, 'Donation Reminder', 'You have to pay 5000 as you promised', platformChannelSpecifics,
        payload: 'item x');



    Fluttertoast.showToast(
        msg: "Reminder set successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.of(context, rootNavigator: true).pop(context);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Donation Reminder"),
      ),
      body: Container(
        padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
    child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AspectRatio(
          aspectRatio: 16 / 9,
          child:
          Container(
            margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

            alignment: Alignment.center,
            // height: ScreenUtil().setHeight(175),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage("assets/bg_reminder.png"),

                alignment: Alignment.center,
              ),

            ),

          )),
      SizedBox(height: 20,),
          Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child:  Image(
                      image: new AssetImage("assets/ic_calendar.png"),
                      width: 70,
                      height:  70,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),),
                Expanded(
                  flex: 3,
                  child:  Text("Your Donation Date has arrived.Please fulfill your promise and donate with full heart and faith.",


                    style: GoogleFonts.roboto(
                      fontSize:16.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,

                    ),),),


              ]),
SizedBox(height: 30,),
      Center(child:GestureDetector(
          onTap: () {






          },child:Container(
        height: 50,
        width:170,
        margin:EdgeInsets.fromLTRB(0,0,0,10) ,
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
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        padding: EdgeInsets.fromLTRB(0,8,0,8),
        child: Align(
          alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
          child:  Text("DONATE NOW",

            style: GoogleFonts.poppins( letterSpacing: 1.2,fontSize: ScreenUtil().setSp(16), color:  Color(0xFFffffff),fontWeight: FontWeight.w500),),
        ),


      ))),
      SizedBox(height: 20,),
      Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child:  GestureDetector(
                    onTap: () =>
                    {
                      scheduleNotification(1)

                    },
                    child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.fromLTRB(3.0,12.0,3.0,12.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0) //                 <--- border radius here
                          ),

                        ),
                        child: Text("Remind Me Tomorrow",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize:14.0,

                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w500,

                            ))))),

            Expanded(
                flex: 1,
                child:GestureDetector(
                    onTap: () =>
                    {
                      scheduleNotification(7)
                    //  _asyncInputDialog(context)

                    },
                    child:Container(

                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.fromLTRB(3.0,12.0,3.0,12.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0) //                 <--- border radius here
                          ),
                        ),
                        child:Text("Remind Me Next Week",
                          textAlign: TextAlign.center,

                          style: GoogleFonts.roboto(
                            fontSize:14.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ),)))),



          ]

      ),

    ])),

    );
  }


}