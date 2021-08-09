import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyBooksTab.dart';
import 'BooksByLanguage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Repository/MainRepository.dart';
import 'BooksDetail.dart';
import'../ApiResponses/BookListResponse.dart';
import '../Views/BookGroupList.dart';
import '../ApiResponses/BookData.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
class SeeALLBooksPage extends StatefulWidget {
  final List<BookData> bookArray;
  final String name;


  SeeALLBooksPage({Key key,@required this.bookArray,@required this.name}) : super(key: key);

  @override
  SeeALLBooksPageState createState() {
    return SeeALLBooksPageState(bookArray,name);
  }
}

class SeeALLBooksPageState extends State<SeeALLBooksPage> {
  List<BookData> mBookArray;
   String mName;
  SeeALLBooksPageState(List<BookData> bookArray,String name){
    mBookArray=bookArray;
    mName=name;
  }

 // List mainData = new List();
 // bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {




      return (prefs.getString('token'));
    });

  }


  Widget _buildBoxBook(BuildContext context,int id,String title,String thumbnail,String publisher){



    return    Container(
        margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
        height: 175,
        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              Container(
                margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                height: 150,
                alignment: Alignment.center,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(thumbnail),
                  ),
                ),

              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,4,0,0),
                  child:
                  Text(title,   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.roboto(
                      fontSize:13.0,
                      color: Color(0xFF1f2833).withOpacity(1),

                    ),)),

              Padding(
                  padding: EdgeInsets.fromLTRB(10,2,0,0),
                  child: Text(publisher,   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.roboto(
                      fontSize:11.0,
                      color: Color(0xFF5a5a5a),

                    ),)),
            ]));
  }

  @override
  Widget build(BuildContext context) {

    print("my_=width"+MediaQuery.of(context).size.width.toString());
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text(mName+ " Books", style: GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 23,color: Color(0xFFFFFFFF))),

      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(4,10,0,0),
          padding:  EdgeInsets.symmetric(horizontal: 2),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                Expanded(
                    child:Padding(
                        padding: EdgeInsets.fromLTRB(4,0,4,0),

                        child: GridView.builder(

                          itemCount: mBookArray.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12.0,
                              childAspectRatio: (1 / 1.8),
                              mainAxisSpacing: 4.0
                          ),
                          itemBuilder: (BuildContext context, int index){

                            return GestureDetector(
                                onTap: () =>
                                {

                                  Navigator.of(context, rootNavigator: true)
                                      .push( // ensures fullscreen
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return BooksDetailPage(content: mBookArray[index]);
                                          }
                                      ))
                                },
                                child: _buildBoxBook(context, mBookArray[index].id, mBookArray[index].title,
                                    mBookArray[index].thumbImage, mBookArray[index].publisher));
                          },
                        )))


              ])


      ),

    );
  }


}