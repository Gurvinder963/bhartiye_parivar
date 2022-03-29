import 'dart:convert';

import 'package:bhartiye_parivar/ApiResponses/InformationAPIResponse.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:bhartiye_parivar/Views/AboutUs.dart';
import 'package:bhartiye_parivar/Views/ContactUs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Repository/MainRepository.dart';


class InformationPage extends StatefulWidget {

final String channelId;


  InformationPage({Key key,@required this.channelId}) : super(key: key);


  @override
  InformationPageState createState() {
    return InformationPageState(channelId);
  }
}


class InformationPageState extends State<InformationPage> {

String channelId;

InformationPageState(channelId){
this.channelId=channelId;
}



  String USER_ID;
  String user_Token;
  
  String msg="";

  @override
  void initState() {
    super.initState();



    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);
     

      getList(user_Token,"").then((value) => {
        {



          setState(() {
            if(value.data!=null && value.data.length>0){
               msg=value.data[0].information;
               print("msg---"+msg);
               }
           // _isInAsyncCall = false;
           // isLoading = false;
           //  mainData.addAll(value.data);

          })
        }
      });

      return (prefs.getString('token'));
    });

  }

  Future<InformationAPIResponse> getList(String user_Token,String keyword) async {
   print(keyword);
    var body =json.encode({"app_code":Constants.AppCode,"channel_id":channelId,"token": user_Token,"userid": USER_ID,});
    MainRepository repository=new MainRepository();
    return repository.fetchInformationAPIJAVA(body);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('Information'),
      ),
      body:   Container(
          width: double.infinity ,
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.fromLTRB(10,30,10,10),
                  child:  Text(msg,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                ),
                 SizedBox(height: 40,),
                _aboutButton(),
                _ContactButton(),

              ])

      ),

    );
  }
  Widget _aboutButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return AboutUsPage(channelId:channelId);
                }
            ) );
      },

      child: Container(
        width: 220,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
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
          'About '+Constants.AppName,
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  Widget _ContactButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return ContactUsPage(channelId: channelId,);
                }
            ) );
      },

      child: Container(
        width: 220,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
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
          'Contact '+Constants.AppName,
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}