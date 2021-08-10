import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Views/DashedLinePainter.dart';
import '../Views/LineDashedPainter.dart';
import '../Utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackOrderPage extends StatefulWidget {
  @override
  TrackOrderPageState createState() {
    return TrackOrderPageState();
  }
}

class TrackOrderPageState extends State<TrackOrderPage> {

  int id;
  String orderId;
  String orderDate;
  String consignmentNo;
  String orderStatus;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(

      body: Container(child:SizedBox(child:_buildBoxBook(context,id,orderId,orderDate,consignmentNo,orderStatus))),

    );
  }  Widget _trackOrderButton() {
    return InkWell(
      onTap: () {



      },

      child: Container(
        width: 160,
        height: ScreenUtil().setWidth(45),
        margin: EdgeInsets.fromLTRB(0,0,0,10),

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
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'Track now',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.black,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
  Widget _buildBoxBook(BuildContext context,int id,String orderId,String orderDate,String consignmentNo,String orderStatus){



    return   SizedBox (child: Card (child:Container(
        margin:EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0) ,

        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

        Row(
        mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Padding(
                  padding: EdgeInsets.fromLTRB(10,4,0,0),
                  child:
                  Text("Order Id: RAXag98070098",   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.poppins(
                      fontSize:13.0,
                      color: Color(0xFF1f2833).withOpacity(1),

                    ),)),

              Spacer(),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,2,10,0),
                  child: Text("29-04-2021 08:29",   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.poppins(
                      fontSize:11.0,
                      color: Color(0xFF5a5a5a),

                    ),)),
              ]),
        Padding(
            padding: EdgeInsets.fromLTRB(10,8,10,0),
             child: MySeparator(color: Colors.grey)),
              Row(

                  children: <Widget>[
                    Column(

                        children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(10,4,0,0),
                        child:
                        Text("Consignment number:",   overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.poppins(
                            fontSize:13.0,
                            color: Color(0xFF1f2833).withOpacity(1),
                              fontWeight: FontWeight.w600
                          ),)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10,4,0,0),
                              child:
                              Text("RD123456789IN",   overflow: TextOverflow.ellipsis,
                                maxLines: 1, style: GoogleFonts.poppins(
                                  fontSize:13.0,
                                  color: Color(0xFF1f2833).withOpacity(1),

                                ),)),

                        ]),

                    Spacer(),
                    CustomPaint(painter: LineDashedPainter()),
                    Spacer(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(10,4,10,0),
                              child:
                              Text("Order status:",   overflow: TextOverflow.ellipsis,
                                maxLines: 1, style: GoogleFonts.poppins(
                                  fontSize:13.0,
                                  color: Color(0xFF1f2833).withOpacity(1),
                                    fontWeight: FontWeight.w600
                                ),)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10,4,0,0),
                              child:
                              Text("Posted",   overflow: TextOverflow.ellipsis,
                                maxLines: 1, style: GoogleFonts.poppins(
                                  fontSize:13.0,
                                  color: Color(0xFF1f2833).withOpacity(1),

                                ),)),

                        ]),
                  ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,8,10,0),
                  child: MySeparator(color: Colors.grey))

              ,Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                        padding: EdgeInsets.fromLTRB(10,4,0,0),
                        child:
                        Text("Book List",   overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.poppins(
                            fontSize:13.0,

                            color: Color(0xFF000000)

                          ),)),

                    Spacer(),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10,8,10,0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Color(AppColors.BaseColor),
                                border: Border.all(color: Colors.black)
                            ),
                            padding: EdgeInsets.fromLTRB(5,3,5,3),

                            child:Text("Download Invoice",overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.poppins(
                            fontSize:12.0,

                            color: Color(0xFF000000),

                          ),))),
                  ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,20,10,0),
                  child:
                  Text("Track your Consignment number from this link below \nafter the order status change to posted.",   textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                        fontSize:12.0,

                        color: Color(0xFF000000)

                    ),)),
              SizedBox(height: 20),
              _trackOrderButton(),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,8,10,0),
                  child:
                  Text("Did n't get you order yet?",   textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                      fontSize:12.0,

                      color: Color(0xFF000000)

                  ),)),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,12,10,0),
                  child:
                  Text("Contact us",   textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                      fontSize:12.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xFF000080),
                      fontWeight: FontWeight.w600
                  ),)),
            ]))));
  }

}