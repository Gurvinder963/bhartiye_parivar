import 'dart:convert';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/LangResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../Utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../localization/locale_constant.dart';
import '../localization/localizations_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class ContentLanguagePage extends StatefulWidget {
  @override
  ContentLanguagePageState createState() {
    return ContentLanguagePageState();
  }
}

class ContentLanguagePageState extends State<ContentLanguagePage> {
  String user_Token;
  bool _isInAsyncCall=false;

  Future<LangResponse> getLangAPI(String user_Token) async {

    var body ={'app_unique_code':Constants.AppCode};
    MainRepository repository=new MainRepository();
    return repository.fetchLangData(body,user_Token);

  }
  Future<AddToCartResponse> saveLangAPI(applang) async {
    //  final String requestBody = json.encoder.convert(order_items);


    var body =json.encode({"unique_id":"","app_unique_code":Constants.AppCode,"content_langauges":applang});
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
      getLangAPI(user_Token).then((value) => {

      setState(() {
      var mainArray = value.data.contentLangauges.split(',');

      for (int z = 0; z < mainArray.length; z++) {
      var item = mainArray[z];
      print("my_item" + item);

      for (int i = 0; i < choices.length; i++) {
      if (item == choices[i].lnCode) {
      choices[i].isSelected = true;
      break;
      }
      }
      }
      })

      });

      return (prefs.getString('token'));
    });




    // getLocaleContentLang().then((locale) {
    //
    //   if(locale!=null) {
    //     setState(() {
    //       var mainArray = locale.split(',');
    //
    //       for (int z = 0; z < mainArray.length; z++) {
    //         var item = mainArray[z];
    //         print("my_item" + item);
    //
    //         for (int i = 0; i < choices.length; i++) {
    //           if (item == choices[i].lnCode) {
    //             choices[i].isSelected = true;
    //             break;
    //           }
    //         }
    //       }
    //     });
    //   }
    //
    // });

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Color(AppColors.BaseColor),
          title: Text('Content Language'),
        ),
      body: ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:

      Container(
          width: double.infinity ,

        padding: EdgeInsets.fromLTRB(10,0,10,0),

        child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(

            AppStrings.chossethelangmsg,
            textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
          SizedBox(height: 10),
          new Expanded(
         child:GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              children: List.generate(choices.length, (index) {

                Choice choice= choices[index];
                var color1= choice.isSelected?Color(AppColors.BaseColor):Color(AppColors.disaledcardcolor);
                var color2= choice.isSelected?Colors.white:Color(AppColors.BaseColor);

                return
                  GestureDetector(
                      onTap: () {

                        var flag=choice.isSelected?false:true;

                        setState(() {


                          choice.isSelected = flag;
                        });


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
                                            padding: EdgeInsets.fromLTRB(5,5,0,0),
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
                ;
              }
              ))),
          _submitButton()
              ])))

    );
  }
  void changeLanguage(BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocaleContentLang(selectedLanguageCode);

  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        StringBuffer sb = new StringBuffer();

        for(int i = 0; i < choices.length; i++){

          if (choices[i].isSelected) {
            if(i!=0){
              sb.write(",");
            }
            sb.write(choices[i].lnCode);

          }

        }
 setState(() {
           _isInAsyncCall = true;
         });
        saveLangAPI(sb.toString()).then((res) async {
          String msg;
           setState(() {
             _isInAsyncCall = false;
           });
          if(res.status==1){



            changeLanguage(context,sb.toString());
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
          'Submit',
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
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

