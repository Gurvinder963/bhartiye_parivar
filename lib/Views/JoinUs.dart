import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'../ApiResponses/JoinUsResponse.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';

class DayObject {
  String title;
  bool isSelected;

  DayObject({
    this.title,
    this.isSelected,
  });
}

String amount="";
String selectedDonateType="";
String selectedDate="";
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
  String user_Token;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }


      getJoinUsDataAPI(user_Token).then((value) => {

        setJoinUsData(value)



      });



     //  var array="[\"Not much, but can come for meetings at the district level once or twice a month\", \"No, I can not.\", \"No, I am not financially capable\", \"[Satsang or Dharmguru]\"]";
     //
     //  var lists = json.decode(array);
     // // print(lists[3]);
     //  setState(() {
     //    _chosenValue1 = lists[0];
     //   _chosenValue2 = lists[1];
     //   _chosenValue3 = lists[2];
     //  });
     //  var lists1 = lists[3];
     //
     //
     //  for(int i = 0; i < lists1.length; i++){
     //     print(lists1[i]);
     //    if (lists1[i]=="Satsang or Dharmguru") {
     //      setState(() {
     //        checkedValue1 = true;
     //
     //      });
     //    }
     //    if (lists1[i]=="Political Party") {
     //      setState(() {
     //        checkedValue2 = true;
     //
     //      });
     //    }
     //    if (lists1[i]=="Non-Political Movement") {
     //      setState(() {
     //        checkedValue3 = true;
     //
     //      });
     //    }
     //
     //
     //
     //  }


      return (prefs.getString('token'));
    });

  }

  setJoinUsData(value){

    var lists = json.decode(value.data.content);
    setState(() {
      _chosenValue1 = lists[0];
      _chosenValue2 = lists[1];
      _chosenValue3 = lists[2];

    });
    var lists1 = json.decode(value.data.contentMultiple);
     for(int i = 0; i < lists1.length; i++){
        print(lists1[i]);
       if (lists1[i]=="Satsang or Dharmguru") {
         setState(() {
           checkedValue1 = true;

         });
       }
       if (lists1[i]=="Political Party") {
         setState(() {
           checkedValue6 = true;

         });
       }
       if (lists1[i]=="Non-Political Movement") {
         setState(() {
           checkedValue2 = true;

         });
       }
        if (lists1[i]=="Ambedkarite Ideology") {
          setState(() {
            checkedValue3 = true;

          });
        }
        if (lists1[i]=="Rajiv Dixit Ideology") {
          setState(() {
            checkedValue4 = true;

          });
        }
        if (lists1[i]=="Communist Ideology") {
          setState(() {
            checkedValue5 = true;

          });
        }
        if (lists1[i]=="Socialist Ideology") {
          setState(() {
            checkedValue7 = true;

          });
        }
        if (lists1[i]=="RSS Ideology") {
          setState(() {
            checkedValue8 = true;

          });
        }
        if (lists1[i]=="Gandhian Ideology") {
          setState(() {
            checkedValue9 = true;

          });
        }
        if (lists1[i]=="Others") {
          setState(() {
            checkedValue10 = true;

          });
        }



     }


  }

  Future<AddToCartResponse> saveJoinUsAPI(message,message1) async {
    //  final String requestBody = json.encoder.convert(order_items);


    var body =json.encode({"content":message,"content_multiple":message1,"amount":amount,"remainder_date":selectedDate,"remainder_type":selectedDonateType});
    MainRepository repository=new MainRepository();

    return repository.fetchJoinUsSave(body,user_Token);


  }

  Future<JoinUsResponse> getJoinUsDataAPI(String user_Token) async {

    var body ={'lang_code':""};
    MainRepository repository=new MainRepository();
    return repository.fetchJoinUsData(body,user_Token);

  }
  showAlertDialogValidation(BuildContext context,String message) {

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Constants.AppName),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  Future _asyncInputDialog(BuildContext context) async {
    String teamName1 = '';
    String teamName2 = '';
    String teamName3 = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        int selectedRadio = -1;
        String selectedDay = "";
        List mainData = new List();

        for(int i = 1; i < 32; i++){

          mainData.add(DayObject(title: i.toString(), isSelected: false,));
        }


        return AlertDialog(
            content:  SizedBox(
            height: 430,child:StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
              height: 500 ,child:Column(
            children: <Widget>[
              Text("How much amount you want to donate monthly",

                  style: GoogleFonts.roboto(
                    fontSize:16.0,

                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w500,

                  )),

            SizedBox(height: 20,),
            new Row(

              children: <Widget>[
                SizedBox(width: 5,),
                new Radio(
                  value: 100,
                  activeColor: Colors.orange,
                  groupValue: selectedRadio,
                  onChanged: (int value) {
                    setState(() => selectedRadio = value);
                  },
                ),
                new Text(
                  '100',

                  style: new TextStyle(fontSize: 14.0),
                ),
                SizedBox(width: 10,),
                new Radio(
                  value: 200,
                  activeColor: Colors.orange,
                  groupValue: selectedRadio,
                  onChanged: (int value) {
                    setState(() => selectedRadio = value);
                  },
                ),
                new Text(
                  '200',
                  style: new TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(width: 10,),
                new Radio(
                  value: 300,
                  activeColor: Colors.orange,

                  groupValue: selectedRadio,
                  onChanged: (int value) {
                    setState(() => selectedRadio = value);
                  },
                ),
                new Text(
                  '300',
                  style: new TextStyle(fontSize: 14.0),
                ),
              ],
            ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Radio(
                    value: 1000,
                    activeColor: Colors.orange,
                    groupValue: selectedRadio,
                    onChanged: (int value) {
                      setState(() => selectedRadio = value);
                    },
                  ),
                  new Text(
                    '1000',
                    style: new TextStyle(fontSize: 14.0),
                  ),
                  new Radio(
                    value: 2000,
                    activeColor: Colors.orange,
                    groupValue: selectedRadio,
                    onChanged: (int value) {
                      setState(() => selectedRadio = value);
                    },
                  ),
                  new Text(
                    '2000',
                    style: new TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  new Radio(
                    value: 5000,
                    activeColor: Colors.orange,
                    groupValue: selectedRadio,
                    onChanged: (int value) {
                      setState(() => selectedRadio = value);
                    },
                  ),
                  new Text(
                    '5000',
                    style: new TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 10,),

              Divider(
                thickness: 1.5,
                color:Colors.orange,
              ),
              SizedBox(height: 10,),
              Text("Please select your monthly date of donation",

                  style: GoogleFonts.roboto(
                    fontSize:13.0,

                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w500,

                  )),
              SizedBox(height: 20,),
              Expanded(child:SizedBox(
                  height: 200,width:300,

                  child:
              GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: mainData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 15.0,
                    childAspectRatio: (1 / 1),
                    mainAxisSpacing: 15.0
                ),
                itemBuilder: (BuildContext context, int index){

                  return GestureDetector(
                      onTap: () =>
                      {

                      for(int i = 0; i < mainData.length; i++){

                     mainData[i].isSelected=false
                  },

                        setState(() {
                        }),
                        mainData[index].isSelected=true,
                        setState(() {
                          selectedDay=mainData[index].title;
                        }),
                      },
                      child:    Container(
                          padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,2.0),
                          decoration: BoxDecoration(
                            color: mainData[index].isSelected?Colors.orange:Colors.white,
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.all(
                                Radius.circular(1.0) //                 <--- border radius here
                            ),

                          ),
                          child:Center(child:Text(mainData[index].title,   overflow: TextOverflow.ellipsis,
                       style: GoogleFonts.roboto(
                          fontSize:12.0,
                          color: mainData[index].isSelected?Colors.white:Color(0xFF333333),

                        ),))));
                },
              )))
            ]
          ));
        },
        )), actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              setState(() {
                selectedDay="";
                selectedRadio=-1;
              });


              Navigator.of(context).pop();
            },
          ),

          FlatButton(
            child: Text('Submit'),
            onPressed: () {

              if(selectedRadio==-1){
                showAlertDialogValidation(context, "Please select amount");
              }else if(selectedDay==""){
                showAlertDialogValidation(context, "Please select month date");
              }
              else {
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('yyyy/MM/dd');
                final String formatted = formatter.format(now);
                var arr=formatted.split('/');

                amount=selectedRadio.toString();
                selectedDonateType="1";
                selectedDate=arr[0]+"/"+arr[1]+"/"+selectedDay;
                print(selectedRadio);
                print(selectedDate);

                Navigator.of(context).pop();
              }


            },
          ),
        ],



        );
      },
    );
  }

  Future _asyncInputDialogYearly(BuildContext context) async {
    String teamName1 = '';
    String teamName2 = '';
    String teamName3 = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        int selectedRadio = -1;



        return AlertDialog(
          content:  SizedBox(
              height: 200,child:StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  height: 200 ,child:Column(
                  children: <Widget>[
                    Text("How much amount you want to donate yearly",

                        style: GoogleFonts.roboto(
                          fontSize:16.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        )),

                    SizedBox(height: 20,),
                    new Row(

                      children: <Widget>[

                        new Radio(
                          value: 1100,
                          activeColor: Colors.orange,
                          groupValue: selectedRadio,
                          onChanged: (int value) {
                            setState(() => selectedRadio = value);
                          },
                        ),
                        new Text(
                          '1100',

                          style: new TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(width: 8,),
                        new Radio(
                          value: 2100,
                          activeColor: Colors.orange,
                          groupValue: selectedRadio,
                          onChanged: (int value) {
                            setState(() => selectedRadio = value);
                          },
                        ),
                        new Text(
                          '2100',
                          style: new TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(width: 8,),
                        new Radio(
                          value: 5100,
                          activeColor: Colors.orange,

                          groupValue: selectedRadio,
                          onChanged: (int value) {
                            setState(() => selectedRadio = value);
                          },
                        ),
                        new Text(
                          '5100',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          value: 11000,
                          activeColor: Colors.orange,
                          groupValue: selectedRadio,
                          onChanged: (int value) {
                            setState(() => selectedRadio = value);
                          },
                        ),
                        new Text(
                          '11000',
                          style: new TextStyle(fontSize: 13.0),
                        ),
                        new Radio(
                          value: 21000,
                          activeColor: Colors.orange,
                          groupValue: selectedRadio,
                          onChanged: (int value) {
                            setState(() => selectedRadio = value);
                          },
                        ),
                        new Text(
                          '21000',
                          style: new TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        new Radio(
                          value: 51000,
                          activeColor: Colors.orange,
                          groupValue: selectedRadio,
                          onChanged: (int value) {
                            setState(() => selectedRadio = value);
                          },
                        ),
                        new Text(
                          '51000',
                          style: new TextStyle(fontSize: 13.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),




                  ]
              ));
            },
          )), actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              setState(() {

                selectedRadio=-1;
              });
              Navigator.of(context).pop();
            },
          ),

          FlatButton(
            child: Text('Submit'),
            onPressed: () {

              if(selectedRadio==-1){
                showAlertDialogValidation(context, "Please select amount");
              }
              else {
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('yyyy/MM/dd');
                final String formatted = formatter.format(now);

                amount=selectedRadio.toString();
                selectedDonateType="2";
                selectedDate=formatted;
                Navigator.of(context).pop();

                print(selectedRadio);

              }


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

                                    if(value=='Yes, every Month'){
                                      _asyncInputDialog(context);

                                    }else if(value=='Yes, once in a year'){
                                      _asyncInputDialogYearly(context);

                                    }



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

              List mainData = new List();
              List<String> checkedMainData = new List();

           if(_chosenValue1=="Select your answer"){
               showAlertDialogValidation(context, "Please select your answer");
           }
           else if(_chosenValue2=="Select your answer"){
             showAlertDialogValidation(context, "Please select your answer");
           }
           else if(_chosenValue3=="Select your answer"){
             showAlertDialogValidation(context, "Please select your answer");
           }
           else{
             mainData.add('"'+_chosenValue1+'"');
             mainData.add('"'+_chosenValue2+'"');
             mainData.add('"'+_chosenValue3+'"');

             if(checkedValue1){

               var value="Satsang or Dharmguru";
               checkedMainData.add('"'+value+'"');

             }
             if(checkedValue2){
               var value="Non-Political Movement";
               checkedMainData.add('"'+value+'"');

              }
             if(checkedValue3){
               var value="Ambedkarite Ideology";
               checkedMainData.add('"'+value+'"');

             }
             if(checkedValue4){

               var value="Rajiv Dixit Ideology";
               checkedMainData.add('"'+value+'"');

             }
             if(checkedValue5){

               var value="Communist Ideology";
               checkedMainData.add('"'+value+'"');
             }
             if(checkedValue6){

               var value="Political Party";
               checkedMainData.add('"'+value+'"');
             }
             if(checkedValue7){

               var value="Socialist Ideology";
               checkedMainData.add('"'+value+'"');
             }
             if(checkedValue8){

               var value="RSS Ideology";
               checkedMainData.add('"'+value+'"');
             }
             if(checkedValue9){

               var value="Gandhian Ideology";
               checkedMainData.add('"'+value+'"');
             }
             if(checkedValue10){

               var value="Others";
               checkedMainData.add('"'+value+'"');
             }

            /// mainData.add('"'+checkedMainData.toString()+'"');

             print(mainData);

             setState(() {
               _isInAsyncCall = true;
             });


             saveJoinUsAPI(mainData.toString(),checkedMainData.toString()).then((res) async {
               String msg;
               setState(() {
                 _isInAsyncCall = false;
               });
               Fluttertoast.showToast(
                   msg: "Data save successfully",
                   toastLength: Toast.LENGTH_SHORT,
                   gravity: ToastGravity.BOTTOM,
                   timeInSecForIosWeb: 1,
                   backgroundColor: Colors.black,
                   textColor: Colors.white,
                   fontSize: 16.0);
               Navigator.of(context, rootNavigator: true).pop(context);

             });


           }


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