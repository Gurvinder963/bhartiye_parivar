import 'dart:convert';
import 'package:bhartiye_parivar/Views/InformationPage.dart';
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
import '../ApiResponses/JoinUsNewResponse.dart';

class DayObject {
  String title;
  bool isSelected;

  DayObject({
    this.title,
    this.isSelected,
  });
}

class User {
  const User(this.id,this.name);

  final String name;
  final int id;
}

String amount="0";
String selectedDonateType="";
String selectedDate="0";
class JoinUsPage extends StatefulWidget {
final String channel_id;


  JoinUsPage({Key key,@required this.channel_id}) : super(key: key);


  @override
  JoinUsPageState createState() {
    return JoinUsPageState(channel_id);
  }
}

class JoinUsPageState extends State<JoinUsPage> {

  String channelId;

  JoinUsPageState(String channel_id){
   this.channelId=channel_id;
  }

  //String _chosenValue1="Select your answer";
  User _chosenValue1;
  User _chosenValue2;
  User _chosenValue3;

  List<User> ansList1 = <User>[const User(0,'Select your answer'),
      const User(1,'Yes, at the national level I can give at least 15-20 days in a month and can also come to Delhi for this'),
     const User(2,'Yes, I can give at least 3-4 days in a month to strengthen the organization at district level')
    , const User(3,'Not much, but can come for meetings at the district level once or twice a month')
    , const User(4,'No, I don not have time')
  ];

  List<User> ansList2 = <User>[const User(0,'Select your answer'),
    const User(1,'Yes, I can be active on social media.'),
    const User(2,'No, I can not.')
  ];

  List<User> ansList3 = <User>[const User(0,'Select your answer'),
    const User(1,'Yes, every Month'),
    const User(2,'Yes, once in a year'),
    const User(3,'No, I am not financially capable'),
  ];





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

  String USER_ID;
  @override
  void initState() {
    _chosenValue1=ansList1[0];
    _chosenValue2=ansList2[0];
    _chosenValue3=ansList3[0];
    SystemChrome.setPreferredOrientations([

      DeviceOrientation.portraitUp,

    ]);
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }



      getJoinUsDatajavaAPI(user_Token).then((value) => {

       setJoinUsData(value),



      });


      // getJoinUsDataAPI(user_Token).then((value) => {
      //
      //   setJoinUsData(value)
      //
      //
      //
      // });



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


    if(value.data.length>0){


      String date=value.data[0].promiseDate;
      var arr=date.split("-");

    //var lists = json.decode(value.data.content);
    setState(() {
       amount=value.data[0].amount;
       selectedDate=arr[2];
      _chosenValue1 = ansList1[int.parse(value.data[0].timeLevel)];
      _chosenValue2 = ansList2[int.parse(value.data[0].socialMedia)];
      _chosenValue3 = ansList3[int.parse(value.data[0].donationFrequency)];

    });
    var lists1 =  value.data[0].contentMultiple.split(',');
     for(int i = 0; i < lists1.length; i++){
        print(lists1[i]);
       if (lists1[i]=="1") {
         setState(() {
           checkedValue1 = true;

         });
       }
       if (lists1[i]=="6") {
         setState(() {
           checkedValue6 = true;

         });
       }
       if (lists1[i]=="2") {
         setState(() {
           checkedValue2 = true;

         });
       }
        if (lists1[i]=="3") {
          setState(() {
            checkedValue3 = true;

          });
        }
        if (lists1[i]=="4") {
          setState(() {
            checkedValue4 = true;

          });
        }
        if (lists1[i]=="5") {
          setState(() {
            checkedValue5 = true;

          });
        }
        if (lists1[i]=="7") {
          setState(() {
            checkedValue7 = true;

          });
        }
        if (lists1[i]=="8") {
          setState(() {
            checkedValue8 = true;

          });
        }
        if (lists1[i]=="9") {
          setState(() {
            checkedValue9 = true;

          });
        }
        if (lists1[i]=="10") {
          setState(() {
            checkedValue10 = true;

          });
        }



     }

    }
  }

  Future<AddToCartResponse> saveJoinUsAPI(message1) async {
    //  final String requestBody = json.encoder.convert(order_items);


    print("--f aggggn----");
    print(selectedDate);


    var body =json.encode({"app_code":Constants.AppCode,"channel_id":channelId,"userid":USER_ID,"token":user_Token,"social_media":_chosenValue2.id.toString(),"time_level":_chosenValue1.id.toString(),"donation_frequency":_chosenValue3.id.toString(),"amount":amount,"promise_date":selectedDate,"content_multiple":message1});
    MainRepository repository=new MainRepository();

    return repository.fetchSaveJoinUsJAVA(body);


  }

  Future<JoinUsNewResponse> getJoinUsDatajavaAPI(String user_Token) async {

    var body =json.encode({"app_code":Constants.AppCode,"channel_id":channelId,"userid":USER_ID,"token":user_Token});
    MainRepository repository=new MainRepository();
    return repository.fetchGetJoinUsJAVA(body);

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

        for(int i = 1; i < 29; i++){

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

                  style: new TextStyle(fontSize: 13.0),
                ),
                SizedBox(width: 5,),
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
                    fontSize: 13.0,
                  ),
                ),
                SizedBox(width: 5,),
               
              ],
            ),
              new Row(
               
                children: <Widget>[
                   new Radio(
                  value: 500,
                  activeColor: Colors.orange,

                  groupValue: selectedRadio,
                  onChanged: (int value) {
                    setState(() => selectedRadio = value);
                  },
                ),
                new Text(
                  '500',
                  style: new TextStyle(fontSize: 13.0),
                ),
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
                    style: new TextStyle(fontSize: 13.0),
                  ),
              
                ],
              ),
              SizedBox(height: 7,),
 new Row(
               
                children: <Widget>[
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
                    style: new TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
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
                ],
              ),
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
               // selectedDate=arr[0]+"/"+arr[1]+"/"+selectedDay;
                selectedDate=selectedDay;
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
              height: 220,child:StatefulBuilder(
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
                        SizedBox(width: 15,),
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
                      
                      ],
                    ),


 new Row(

                      children: <Widget>[

                     
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
   SizedBox(width: 10,),
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
                      ],
                    ),


                    new Row(
                    
                      children: <Widget>[
                      
                      
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
SizedBox(width: 2,),
                          new Radio(
                          value: 125000,
                          activeColor: Colors.orange,
                          groupValue: selectedRadio,
                          onChanged: (int value) {
                            setState(() => selectedRadio = value);
                          },
                        ),
                        new Text(
                          '125000',
                          style: new TextStyle(
                            fontSize: 13.0,
                          ),
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
                final DateFormat formatter = DateFormat('yyyy-MM-dd');
                final String formatted = formatter.format(now);

                amount=selectedRadio.toString();
                selectedDonateType="2";
                selectedDate="0";
                Navigator.of(context).pop();
                print("----selected date-----");
                print(selectedDate);

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
        title: Text("Join "+Constants.AppName),
     actions: <Widget>[
            GestureDetector(
                onTap: () {
                    Navigator.of(context, rootNavigator: true)
                                      .push(// ensures fullscreen
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                    return InformationPage(channelId:channelId);
                                  }));
                },
                child: new Image(
                  image: new AssetImage("assets/ic_question.png"),
                  width: 30,
                  height: 30,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                )),
            SizedBox(
              width: 15,
            )
          ]
     
      ),

      body:   ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:Stack(  children: [

      Container(
          height:(MediaQuery.of(context).size.height)*0.87 ,
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
                padding:EdgeInsets.fromLTRB(2,2.0,2.0,2.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                     Container(
                         padding:EdgeInsets.fromLTRB(5,5.0,5.0,5.0) ,
                         color:Color(0xFFFFFFA500),
                         child:Text("Will you be able to give some time to strengthen the organization at grassroot level?",

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFFffffff),
                          fontWeight: FontWeight.bold,

                        ),)),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(5,0,10,0),
                        child:
                        Container(
                          height: 38,


                          child:DropdownButtonHideUnderline(

                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.orange,
                                ),
                                child: DropdownButton<User>(
                                  isExpanded: true,
                                  focusColor:Colors.orange,
                                  value: _chosenValue1,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.white),
                                  iconEnabledColor:Colors.orange,
                                  items: ansList1.map((User user) {
                                    return DropdownMenuItem<User>(
                                      value: user,
                                      child: Container(
                                          padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
                                          child:Text(user.name,style:TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(14),
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
                                  onChanged: (User value) {
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
              thickness: 1,
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
                padding:EdgeInsets.fromLTRB(2.0,2.0,2.0,0.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
    Container(
      width:MediaQuery.of(context).size.width,
    padding:EdgeInsets.fromLTRB(5,5.0,5.0,5.0) ,
    color:Color(0xFFFFFFA500),
    child:  Text("Will you be part of our social media team?",

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFFffffff),
                          fontWeight: FontWeight.bold,

                        ),)),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(5,0,10,0),
                        child:
                        Container(
                          height: 38,


                          child:DropdownButtonHideUnderline(

                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.orange,
                                ),
                                child: DropdownButton<User>(
                                  isExpanded: true,
                                  focusColor:Colors.orange,
                                  value: _chosenValue2,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.white),
                                  iconEnabledColor:Colors.orange,
                                  items: ansList2.map((User user) {
                                    return DropdownMenuItem<User>(
                                      value: user,
                                      child: Container(
                                          padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
                                          child:Text(user.name,style:TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(14),
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
                                  onChanged: (User value) {
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
              thickness: 1,
              color:Color(0xFFFFA500),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFc3c3c3)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                padding:EdgeInsets.fromLTRB(2.0,2.0,2.0,2.0) ,
                margin:EdgeInsets.fromLTRB(0.0,7.0,0.0,0.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
    Container(
    width:MediaQuery.of(context).size.width,
    padding:EdgeInsets.fromLTRB(5,5.0,5.0,5.0) ,
    color:Color(0xFFFFFFA500),
    child:Text("Will you be able to provide financial support to strengthen the organization?",

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFFffffff),
                          fontWeight: FontWeight.bold,

                        ),)),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(5,0,10,0),
                        child:
                        Container(
                          height: 38,


                          child:DropdownButtonHideUnderline(

                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.orange,
                                ),
                                child: DropdownButton<User>(
                                  isExpanded: true,
                                  focusColor:Colors.orange,
                                  value: _chosenValue3,
                                   underline: Container(
          height: 1,
          color: Colors.transparent,
        ),
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.white),
                                  iconEnabledColor:Colors.orange,
                                  items: ansList3.map((User user) {
                                    return DropdownMenuItem<User>(
                                      value: user,
                                      child: Container(
                                          padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
                                          child:Text(user.name,style:TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(14),
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
                                  onChanged: (User value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _chosenValue3 = value;
                                    });


                                    if(value.name=='Yes, every Month'){
                                      _asyncInputDialog(context);

                                    }else if(value.name=='Yes, once in a year'){
                                      _asyncInputDialogYearly(context);

                                    }
                                    else{
                                     selectedDate="0";
                                     amount="0";

                                     }

                                  },
                                ),// Your Dropdown Code Here,
                              )),

                        ),




                      ),

                    ]))
,  SizedBox(height: 5,),
            Divider(
              thickness: 1,
              color:Color(0xFFFFA500),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFc3c3c3)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                padding:EdgeInsets.fromLTRB(2.0,2.0,2.0,2.0) ,
                margin:EdgeInsets.fromLTRB(0.0,7.0,0.0,0.0) ,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
    Container(
    width:MediaQuery.of(context).size.width,
    padding:EdgeInsets.fromLTRB(5,5.0,5.0,5.0) ,

    color:Color(0xFFFFFFA500),
    child:   Text("Are you associated with any religious, social or political organization, movement, person or idea?",

                        style: GoogleFonts.roboto(
                          fontSize:16.0,

                          color: Color(0xFFffffff),
                          fontWeight: FontWeight.bold,

                        ),)),
                      SizedBox(height: 5,),
                      Divider(
                        thickness: 0.5,
                        color:Color(0xff666666),
                      ),
                Container(
                    height: 35,child:  CheckboxListTile(
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
                    height: 35,child:  CheckboxListTile(
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
                    height: 35,child: CheckboxListTile(
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
                    height: 35,child: CheckboxListTile(
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
                    height: 35,child:CheckboxListTile(
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
                    height: 35,child: CheckboxListTile(
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
                    height: 35,child: CheckboxListTile(
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
                    height: 35,child:CheckboxListTile(
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
                    height: 35,child:CheckboxListTile(
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
                    height: 35,child: CheckboxListTile(
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


                      SizedBox(height: 20,)
                    ]))

  ,Align(
        alignment: FractionalOffset.bottomCenter,
        child:    GestureDetector(
            onTap: () {

              List mainData = new List();
              List<String> checkedMainData = new List();

           if(_chosenValue1.name=="Select your answer"){
               showAlertDialogValidation(context, "Please select your answer");
           }
           else if(_chosenValue2.name=="Select your answer"){
             showAlertDialogValidation(context, "Please select your answer");
           }
           else if(_chosenValue3.name=="Select your answer"){
             showAlertDialogValidation(context, "Please select your answer");
           }
           else{
           //  mainData.add('"'+_chosenValue1+'"');


             if(checkedValue1){

               var value="1";
               checkedMainData.add(value);

             }
             if(checkedValue2){
               var value="2";
               checkedMainData.add(value);

              }
             if(checkedValue3){
               var value="3";
               checkedMainData.add(value);

             }
             if(checkedValue4){

               var value="4";
               checkedMainData.add(value);

             }
             if(checkedValue5){

               var value="5";
               checkedMainData.add(value);
             }
             if(checkedValue6){

               var value="6";
               checkedMainData.add(value);
             }
             if(checkedValue7){

               var value="7";
               checkedMainData.add(value);
             }
             if(checkedValue8){

               var value="8";
               checkedMainData.add(value);
             }
             if(checkedValue9){

               var value="9";
               checkedMainData.add(value);
             }
             if(checkedValue10){

               var value="10";
               checkedMainData.add(value);
             }

             String s = checkedMainData.join(',');

             setState(() {
               _isInAsyncCall = true;
             });


             saveJoinUsAPI(s.toString()).then((res) async {
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
          height: 45,
          width:140,
          margin:EdgeInsets.fromLTRB(0,20,0,10) ,
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


          ]))))

   
    ])),

    );
  }


}