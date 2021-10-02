import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class JoinUsPage extends StatefulWidget {
  @override
  JoinUsPageState createState() {
    return JoinUsPageState();
  }
}

class JoinUsPageState extends State<JoinUsPage> {

  String _chosenValue1="Select your answer";
  String _chosenValue2="Select your answer";
  String _chosenValue3="Select your answer";
  bool checkedValue1=false;
  bool checkedValue2=false;
  bool checkedValue3=false;
  bool checkedValue4=false;
  bool checkedValue5=false;
  bool checkedValue6=false;
  bool checkedValue7=false;
  bool checkedValue8=false;
  bool checkedValue9=false;
  bool checkedValue10=false;
  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop(context),
        ),
        title: Text("Join Bhartiya Parivar"),
      ),

      body:   ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:Stack(  children: [

      Container(
          height:(MediaQuery.of(context).size.height)*0.82 ,
          child:

    SingleChildScrollView (
    child:Container(
          padding:EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0) ,
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFc3c3c3)),
          borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
    ),
                ),
                padding:EdgeInsets.fromLTRB(7.0,13.0,7.0,13.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Will you be able to give some time to strengthen the organization at grassroot level?",

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0,0,10,0),
                        child:
                        Container(
                          height: 38,


                          child:DropdownButtonHideUnderline(

                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.orange,
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  focusColor:Colors.orange,
                                  value: _chosenValue1,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.white),
                                  iconEnabledColor:Colors.orange,
                                  items: <String>[
                                    'Select your answer',
                                    'Yes, at the national level I can give at least 15-20 days in a month and can also come to Delhi for this',
                                    'Yes, I can give at least 3-4 days in a month to strengthen the organization at district level',
                                    'Not much, but can come for meetings at the district level once or twice a month',
                                    'No, I don not have time',

                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                          padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
                                          child:Text(value,style:TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(14),
                                          fontWeight: FontWeight.w500),)),
                                    );
                                  }).toList(),
                                  hint:Text(
                                    "Please choose a langauage",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(14),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (String value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _chosenValue1 = value;
                                    });
                                  },
                                ), // Your Dropdown Code Here,
                              )),

                        ),




                      ),

                    ]))
,
            SizedBox(height: 5,),
            Divider(
              thickness: 0.5,
              color:Color(0xFFFFA500),
            ),

            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFc3c3c3)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                margin:EdgeInsets.fromLTRB(0.0,7.0,0.0,0.0) ,
                padding:EdgeInsets.fromLTRB(7.0,13.0,7.0,13.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Will you be part of our social media team?",

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0,0,10,0),
                        child:
                        Container(
                          height: 38,


                          child:DropdownButtonHideUnderline(

                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.orange,
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  focusColor:Colors.orange,
                                  value: _chosenValue2,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.white),
                                  iconEnabledColor:Colors.orange,
                                  items: <String>[
                                    'Select your answer',
                                    'Yes, I can be active on social media.',
                                        'No, I can not.',

                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                          padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
                                          child:Text(value,style:TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(14),
                                              fontWeight: FontWeight.w500),)),
                                    );
                                  }).toList(),
                                  hint:Text(
                                    "Please choose a langauage",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (String value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _chosenValue2 = value;
                                    });
                                  },
                                ), // Your Dropdown Code Here,
                              )),

                        ),




                      ),

                    ]))
,  SizedBox(height: 5,),
            Divider(
              thickness: 0.5,
              color:Color(0xFFFFA500),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFc3c3c3)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                padding:EdgeInsets.fromLTRB(7.0,13.0,7.0,13.0) ,
                margin:EdgeInsets.fromLTRB(0.0,7.0,0.0,0.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Will you be able to provide financial support to strengthen the organization?",

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0,0,10,0),
                        child:
                        Container(
                          height: 38,


                          child:DropdownButtonHideUnderline(

                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.orange,
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  focusColor:Colors.orange,
                                  value: _chosenValue3,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.white),
                                  iconEnabledColor:Colors.orange,
                                  items: <String>[
                                    'Select your answer',
                                    'Yes, every Month',
                                    'Yes, once in a year',

                                    'No, I am not financially capable',

                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                          padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
                                          child:Text(value,style:TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(14),
                                              fontWeight: FontWeight.w500),)),
                                    );
                                  }).toList(),
                                  hint:Text(
                                    "Please choose a langauage",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (String value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _chosenValue3 = value;
                                    });
                                  },
                                ), // Your Dropdown Code Here,
                              )),

                        ),




                      ),

                    ]))
,  SizedBox(height: 5,),
            Divider(
              thickness: 0.5,
              color:Color(0xFFFFA500),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFc3c3c3)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                padding:EdgeInsets.fromLTRB(7.0,13.0,7.0,13.0) ,
                margin:EdgeInsets.fromLTRB(0.0,7.0,0.0,0.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Are you associated with any religious, social or political organization, movement, person or idea?",

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),
                Container(
                    height: 38,child:  CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: ScreenUtil().setWidth(1)),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Satsang or Dharmguru",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue1,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue1 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),
                Container(
                    height: 40,child:  CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Non-Political Movement",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue2,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue2 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),

                Container(
                    height: 40,child: CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Ambedkarite Ideology",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue3,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue3 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),
                Container(
                    height: 40,child: CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Rajiv Dixit Ideology",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue4,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue4 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),

                Container(
                    height: 40,child:CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Communist Ideology",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue5,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue5 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),

                Container(
                    height: 40,child: CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Political Party",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue6,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue6 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),

                Container(
                    height: 40,child: CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Socialist Ideology",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue7,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue7 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),
                Container(
                    height: 40,child:CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("RSS Ideology",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue8,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue8 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),

                Container(
                    height: 40,child:CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Gandhian Ideology",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue9,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue9 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),
                Container(
                    height: 40,child: CheckboxListTile(
                        contentPadding:EdgeInsets.symmetric(horizontal: 4.0,vertical: 0),
                        activeColor:Colors.orange,
                        checkColor: Colors.white,
                        title:Text("Others",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),),


                        value: checkedValue10,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue10 = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )),
                    ]))



          ]))))

     ,Align(
        alignment: FractionalOffset.bottomCenter,
        child:    GestureDetector(
            onTap: () {





            },child:Container(
          height: 50,
          width:150,
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
            child:  Text("Submit",

              style: GoogleFonts.poppins( letterSpacing: 1.2,fontSize: ScreenUtil().setSp(16), color:  Color(0xFFffffff),fontWeight: FontWeight.w500),),
          ),


        )),
      )

    ])),

    );
  }


}