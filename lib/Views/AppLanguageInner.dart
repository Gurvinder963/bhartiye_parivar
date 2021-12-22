import 'dart:convert';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../Utils/AppColors.dart';
import 'Home.dart';
import '../Utils/AppStrings.dart';
import 'package:google_fonts/google_fonts.dart';
import '../localization/locale_constant.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/LangResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class AppLanguageInnerPage extends StatefulWidget {

  final String from;
  // String langData;
  AppLanguageInnerPage({Key key,@required this.from}) : super(key: key);


  @override
  AppLanguageInnerPageState createState() {
    return AppLanguageInnerPageState(from);
  }
}

class AppLanguageInnerPageState extends State<AppLanguageInnerPage> {
  String mFrom;
  String user_Token;
  bool _isInAsyncCall=false;
  String cnLang='';
  AppLanguageInnerPageState(String from){
    mFrom=from;
  }

  Locale _locale;
  List<Choice> choices =  <Choice>[
    Choice(id:1,title: 'हिन्दी',letter:'अ',isSelected:false,lnCode:'hi'),
    Choice(id:2,title: 'English', letter:'A',isSelected:false,lnCode:'en'),
    Choice(id:3,title: 'ਪੰਜਾਬੀ', letter:'ਓ',isSelected:false,lnCode:'pn'),
    Choice(id:4,title: 'ଓଡ଼ିଆ', letter:'ଅ',isSelected:false,lnCode:'od'),
    Choice(id:5,title: 'ગુજરાતી', letter:'ખ',isSelected:false,lnCode:'gu'),
    Choice(id:6,title: 'मराठी', letter:'अ',isSelected:false,lnCode:'mr'),
    Choice(id:7,title: 'বাংলা', letter:'অ',isSelected:false,lnCode:'ba'),
    Choice(id:8,title: 'தமிழ்', letter:'அ',isSelected:false,lnCode:'te'),
    Choice(id:9,title: 'తెలుగు', letter:'అ',isSelected:false,lnCode:'ta'),
    Choice(id:10,title: 'ಕನ್ನಡ', letter:'ಅ',isSelected:false,lnCode:'ka'),
    Choice(id:11,title: 'മലയാളം', letter:'അ',isSelected:false,lnCode:'ml'),
    Choice(id:12,title: 'অসমীয়া', letter:'অ',isSelected:false,lnCode:'as'),
    Choice(id:13,title: 'মণিপুরী', letter:'অ',isSelected:false,lnCode:'mp'),



  ];
  Future<LangResponse> getLangAPI(String user_Token) async {

    var body ={'app_unique_code':Constants.AppCode};
    MainRepository repository=new MainRepository();
    return repository.fetchLangData(body,user_Token);

  }
  Future<AddToCartResponse> saveLangAPI(applang,cnt_lang) async {
    //  final String requestBody = json.encoder.convert(order_items);
    var body ;
    if(cnt_lang.isEmpty){
      body =json.encode({"unique_id":"","app_unique_code":Constants.AppCode,"app_language":applang});
    }
    else{
      body =json.encode({"unique_id":"","app_unique_code":Constants.AppCode,"app_language":applang,"content_langauges":cnt_lang.toString()});
    }


    MainRepository repository=new MainRepository();

    return repository.fetchSaveUserLang(body,user_Token);


  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      String langData;
      getLangAPI(user_Token).then((value) => {
        print("---data----"),
        print(value),

        // if(value.data==null){
        //   langData="hi"
        //}else{
          langData=value.data.appLanguage,
        //},
      setState(() {
     cnLang=value.data.contentLangauges;
      }),

        getLocale().then((locale) {
          setState(() {
            _locale = locale;

            for(int i = 0; i < choices.length; i++){

              if (choices[i].lnCode == langData) {
                // selectedClassId=mainData[i].id;
                choices[i].isSelected=true;
              } else {                               //the condition to change the highlighted item
                choices[i].isSelected=false;
              }

            }
          });
        })


      });

      return (prefs.getString('token'));
    });



  }
  @override
  Widget build(BuildContext context) {


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1), //or set color with: Color(0xFF0000FF)
    ));
    return  Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: Color(AppColors.BaseColor),
              title: Text('App Language'),
            ),
            body:  ModalProgressHUD(
                inAsyncCall: _isInAsyncCall,
                // demo of some additional parameters
                opacity: 0.01,
                progressIndicator: CircularProgressIndicator(),
                child:SingleChildScrollView (
                    child:
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [

                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,





                        ),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),


                            Padding(
                              padding: EdgeInsets.fromLTRB(30,0,30,10),

                              child: Text(
                                'Choose App Language',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                            SizedBox(
                                height: (MediaQuery.of(context).size.height)*0.82,
                                child:Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.fromLTRB(15,5,15,10),

                                  color: Color(0xFFffffff),


                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30,10,30,10),
                                    child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                                      SizedBox(height: 20),


                                      new Expanded(

                                          child:GridView.count(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 16.0,
                                              mainAxisSpacing: 8.0,
                                              children: List.generate(choices.length, (index) {

                                                Choice choice= choices[index];
                                                var color1= choice.isSelected?Color(AppColors.BaseColor):Color(AppColors.disaledcardcolor);
                                                var color2= choice.isSelected?Colors.white:Color(AppColors.BaseColor);

                                                return
                                                  GestureDetector(
                                                      onTap: () {
                                                        for(int i = 0; i < choices.length; i++){

                                                          if (index == i) {
                                                            // selectedClassId=mainData[i].id;
                                                            choices[i].isSelected=true;
                                                          } else {                               //the condition to change the highlighted item
                                                            choices[i].isSelected=false;
                                                          }

                                                        }
                                                        setState(() {});


                                                      },
                                                      child:Stack(
                                                          alignment: Alignment.topCenter,
                                                          children: [


                                                            Container(



                                                                margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                                decoration: BoxDecoration(
                                                                    color:color1,
                                                                    border: Border.all(
                                                                      color:color1,
                                                                    ),
                                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                                ),
                                                                child:Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.fromLTRB(10,5,0,0),
                                                                        child:
                                                                        Text(choice.title, style: TextStyle(fontSize: 15,color: Colors.white)),
                                                                      ),
                                                                      Center(
                                                                          child:
                                                                          Padding(
                                                                            padding: EdgeInsets.fromLTRB(5,10,0,0),
                                                                            child:
                                                                            Text(choice.letter, style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 40,color: color2)),
                                                                          )

                                                                      ),
                                                                    ])
                                                            ),

                                                            choice.isSelected? Align(
                                                                alignment: Alignment.topRight,
                                                                child: Container(

                                                                    padding: EdgeInsets.all(2),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white ,
                                                                        borderRadius: BorderRadius.circular(100),
                                                                        border: Border.all(width: 1, color: Colors.orange)),
                                                                    child: Icon(Icons.check,color: Colors.green,size: 15,))
                                                            ):Container(),
                                                          ]));

                                              }
                                              ))),


                                      _submitButton()
                                    ]),
                                  ),


                                )),
                          ],
                        ),
                      ],
                    ))),
          );

  }

  void changeLanguageContent(BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocaleContentLang(selectedLanguageCode);

  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        var myLang="";

        for(int i = 0; i < choices.length; i++){

          if (choices[i].isSelected) {

            changeLanguage(context, choices[i].lnCode);
            myLang=choices[i].lnCode;
            break;
          }

        }

        StringBuffer sb = new StringBuffer();



        sb.write(myLang);

        int count=0;
        var mainArray = cnLang.split(',');
        StringBuffer sb1 = new StringBuffer();
        for (int z = 0; z < mainArray.length; z++) {
          if(myLang==mainArray[z]){
            count=count+1;
          }
          sb1.write(mainArray[z]);
          sb1.write(",");
        }

        print(count);
        print(myLang);
        print(cnLang);

       if(count==0){
         sb1.write(myLang);
       }




        String aa=sb1.toString();


        setState(() {
          _isInAsyncCall = true;
        });

        saveLangAPI(sb.toString(),aa).then((res) async {
          String msg;
          setState(() {
            _isInAsyncCall = false;
          });
          if(res.status==1){


            changeLanguageContent(context,aa);



              Navigator.of(context, rootNavigator: true).pop(context);


          }
        });



      },

      child: Container(
        width: 150,
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
          'SAVE',
          style: GoogleFonts.poppins(fontSize: 17, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}class Choice {
  Choice({this.id,this.title, this.letter,this.isSelected,this.lnCode});
  int id;
  String title;
  String letter;
  bool isSelected;
  String lnCode;

}



