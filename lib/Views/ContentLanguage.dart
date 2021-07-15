import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../Utils/AppColors.dart';


class ContentLanguagePage extends StatefulWidget {
  @override
  ContentLanguagePageState createState() {
    return ContentLanguagePageState();
  }
}

class ContentLanguagePageState extends State<ContentLanguagePage> {


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(AppColors.BaseColor),
          title: Text('Content Language'),
        ),
      body:

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
          style: TextStyle(
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
                                        Text(choice.title, style: TextStyle(fontSize: 14,color: Colors.white)),
                                      ),
                                      Center(
                                          child:
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5,5,0,0),
                                            child:
                                            Text(choice.letter, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 38,color: color2)),
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
              ]))

    );
  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {
      /*  Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder:
                (context) =>
                VerifyOTPPage()
            ), ModalRoute.withName("/VerifyOTP")
        );
*/

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
   Choice({this.id,this.title, this.letter,this.isSelected});
   int id;
   String title;
   String letter;
   bool isSelected;

}

 List<Choice> choices =  <Choice>[
   Choice(id:1,title: 'हिन्दी',letter:'अ',isSelected:false ),
   Choice(id:2,title: 'English', letter:'A',isSelected:false),
   Choice(id:3,title: 'ਪੰਜਾਬੀ', letter:'ਓ',isSelected:false),
   Choice(id:4,title: 'ગુજરતી', letter:'ખ',isSelected:false),
   Choice(id:5,title: 'বাংলা', letter:'অ',isSelected:false),
   Choice(id:6,title: 'मराठी', letter:'ळ',isSelected:false),
   Choice(id:7,title: 'தமிழ்', letter:'அ',isSelected:false),
   Choice(id:8,title: 'తెలుగు', letter:'అ',isSelected:false),
   Choice(id:9,title: 'ಕನ್ನಡ', letter:'ಅ',isSelected:false),
   Choice(id:10,title: 'മലയാളം', letter:'അ',isSelected:false),


];

