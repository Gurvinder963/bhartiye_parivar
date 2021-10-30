import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../Utils/AppColors.dart';
import 'Home.dart';
import '../Utils/AppStrings.dart';
import 'package:google_fonts/google_fonts.dart';
import '../localization/locale_constant.dart';
class AppLanguagePage extends StatefulWidget {

  final String from;

  AppLanguagePage({Key key,@required this.from}) : super(key: key);


  @override
  AppLanguagePageState createState() {
    return AppLanguagePageState(from);
  }
}

class AppLanguagePageState extends State<AppLanguagePage> {
   String mFrom;

  AppLanguagePageState(String from){
    mFrom=from;
  }

  Locale _locale;
  List<Choice> choices =  <Choice>[
    Choice(id:1,title: 'हिन्दी',letter:'अ',isSelected:false,lnCode:'hi'),
    Choice(id:2,title: 'English', letter:'A',isSelected:false,lnCode:'en'),
    Choice(id:3,title: 'ਪੰਜਾਬੀ', letter:'ਓ',isSelected:false,lnCode:'pn'),
    Choice(id:4,title: 'ଓଡ଼ିଆ', letter:'ଅ',isSelected:false,lnCode:'od'),
    Choice(id:5,title: 'ગુજરાતી', letter:'ખ',isSelected:false,lnCode:'gu'),
    Choice(id:6,title: 'मराठी', letter:'ळ',isSelected:false,lnCode:'mr'),
    Choice(id:7,title: 'বাংলা', letter:'অ',isSelected:false,lnCode:'ba'),
    Choice(id:8,title: 'தமிழ்', letter:'அ',isSelected:false,lnCode:'te'),
    Choice(id:9,title: 'తెలుగు', letter:'అ',isSelected:false,lnCode:'ta'),
    Choice(id:10,title: 'ಕನ್ನಡ', letter:'ಅ',isSelected:false,lnCode:'ka'),
    Choice(id:11,title: 'മലയാളം', letter:'അ',isSelected:false,lnCode:'ml'),



  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocale().then((locale) {
      setState(() {
        _locale = locale;

        for(int i = 0; i < choices.length; i++){

          if (choices[i].lnCode == locale.languageCode) {
            // selectedClassId=mainData[i].id;
            choices[i].isSelected=true;
          } else {                               //the condition to change the highlighted item
            choices[i].isSelected=false;
          }

        }
      });
    });

  }
  @override
  Widget build(BuildContext context) {


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1), //or set color with: Color(0xFF0000FF)
    ));
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.AppName,
        theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
    )
    ),

    home:SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView (
            child:
            Stack(
              alignment: Alignment.topCenter,
              children: [

                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/2,


                    child: Container(


                      decoration: BoxDecoration(
                        color: Color(AppColors.BaseColor),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(40.0),
                            topLeft: Radius.circular(0.0),
                            bottomLeft: Radius.circular(40.0)),
                      ),

                    )


                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                        height: (MediaQuery.of(context).size.height)*0.18,
                        child:new Image(
                          image: new AssetImage("assets/splash.png"),
                          width: 140,
                          height:  140,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,15,30,0),

                      child: Text(
                        'ऐप की भाषा चुनें',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,0,30,10),

                      child: Text(
                        'Choose App Language',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                    SizedBox(
                        height: (MediaQuery.of(context).size.height)*0.68,
                    child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                        margin: EdgeInsets.fromLTRB(30,5,30,10),

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
            )),
      ),
    ));
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


        if(mFrom=='sign-up'){



       StringBuffer sb = new StringBuffer();

         if(myLang!='en')
           {
             sb.write('en');
             sb.write(',');
           }
       if(myLang!='hi')
       {
         sb.write('hi');
         sb.write(',');
       }

         sb.write(myLang);
       print("String builder value"+sb.toString());
       print("myLang"+myLang);
          changeLanguageContent(context,sb.toString());
        Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder:
                      (context) =>
                      HomePage()
                  ), ModalRoute.withName("/Home")
              );

        }
        else{
          Navigator.of(context, rootNavigator: true).pop(context);
        }






      /*  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return HomePage();
                }
            ) );*/

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
          'NEXT',
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



