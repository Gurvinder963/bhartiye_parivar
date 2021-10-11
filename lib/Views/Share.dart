import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import 'ReferHistory.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';

class SharePage extends StatefulWidget {
  @override
  SharePageState createState() {
    return SharePageState();
  }
}

class SharePageState extends State<SharePage> {
  Future _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Constants.AppName),
          content: SizedBox(
              height: 200,
              child: Column(
            children: [
               TextField(

                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Please Enter Name', ),
                    onChanged: (value) {
                      teamName = value;
                    },
                  ),
            TextField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Please Enter phone', ),
                    onChanged: (value) {
                      teamName = value;
                    },
                  ),
              new TextField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Please Enter Pin', ),
                    onChanged: (value) {
                      teamName = value;
                    },
                  )
            ],
          )),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {

                Navigator.of(context).pop(teamName);
              },
            ),

            FlatButton(
              child: Text('Add'),
              onPressed: () {
                bool isMatched=false;




              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Share App"),
      ),
      body: Container(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            SizedBox(height: 10,),
            Center(child:Text("Sharing report of ankit yadav",

              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.roboto(
                fontSize:15.0,

                color: Color(0xFF000000),
                fontWeight: FontWeight.w500,

              ),)),
SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("",)),
                  Expanded(
                      flex: 1,
                      child:Text("Referred",

                        textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,

                    ),)),
                  Expanded(
                      flex: 1,
                      child:Text("Installed",

                        textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,

                    ),)),
                  Expanded(
                      flex: 1,
                      child:Text("Pending",
                        textAlign: TextAlign.center,

                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,

                    ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Today",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                        fontSize:15.0,

                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,

                      ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Yesterday",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Last 7 Days",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Last 28 Days",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Total",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),

            SizedBox(height: 20,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child:  GestureDetector(
                          onTap: () =>
                          {

                            Navigator.of(context, rootNavigator: true)
                                .push( // ensures fullscreen
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ReferHistoryPage();
                                    }
                                ))
                          },
                          child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.fromLTRB(6.0,8.0,6.0,8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                            color: Color(0xFFcccccc)

                          ),
                          child: Text("Refer History",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))))),
                  Spacer(),
                  Expanded(
                      flex: 3,
                      child:GestureDetector(
                          onTap: () =>
                          {
                            _asyncInputDialog(context)

                          },
                          child:Container(

                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.fromLTRB(6.0,8.0,6.0,8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              color: Color(0xFFcccccc)
                          ),
                          child:Text("Add Refer Details",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)))),



                ]

            ),
          ]
      )

      ),

    );
  }


}