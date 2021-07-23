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
class BooksPage extends StatefulWidget {
  @override
  BooksPageState createState() {
    return BooksPageState();
  }
}

class BooksPageState extends State<BooksPage> {
  List mainData = new List();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      var user_Token=prefs.getString(Prefs.KEY_TOKEN);
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}

      getBooksList(user_Token).then((value) => {

        setState(() {
          isLoading = false;
          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
    });

  }

  Future<BookListResponse> getBooksList(String user_Token) async {

    var body ={'lang_code':'en'};
    MainRepository repository=new MainRepository();
    return repository.fetchBooksData(body,user_Token);

  }
  Widget _buildBoxBook(BuildContext context,int id,String title,String thumbnail,String publisher){



    return    Container(
        margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
    height: 160,
        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
    child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[


      Container(
        margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      height: 140,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
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
    List<String> images = [
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
          "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png"
    ];
    return Scaffold(

        body: Container(
          margin: EdgeInsets.fromLTRB(4,0,0,0),
          padding:  EdgeInsets.symmetric(horizontal: 5),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [




          Row(

             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Expanded(
                  child:   GestureDetector(
                  onTap: () {

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MyBooksTabPage();
                            }
                        ) );

                  },

    child:Stack(
                      alignment: Alignment.center,
        children: <Widget>[

                  new Image(
                    image: new AssetImage("assets/collage.png"),
                    width: 150,
                    height:  150,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),

          Container(

            padding:  EdgeInsets.symmetric(vertical: 7,horizontal: 8),
              decoration: BoxDecoration(
                color:Colors.black ,

                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child:Text("MY BOOKS"
                ,style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white),),
          ),

        ])),
                ),
            
                Expanded(
                  child:  GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return BooksByLanguagePage();
                          }
                      ) );
                },

                child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[

                        new Image(
                          image: new AssetImage("assets/languages.png"),
                          width: 150,
                          height:  150,

                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),

                        Container(
                          padding:  EdgeInsets.symmetric(vertical: 7,horizontal: 8),
                          decoration: BoxDecoration(
                              color:Colors.black ,

                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child:Text("BY LANGUAGE",style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white),),
                        ),

                      ])),
                ),


              ]

          ),
    Padding(
    padding: EdgeInsets.fromLTRB(15,10,10,10),
          child:
          Text("All Books",style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.black,fontWeight: FontWeight.bold),)
    )
,

              Expanded(
                  child:Padding(
                    padding: EdgeInsets.fromLTRB(4,0,4,0),

                  child: GridView.builder(

                    itemCount: mainData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.0,
                        childAspectRatio: (1 / 1.7),
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
                  return BooksDetailPage(content: mainData[index]);
                }
            ))
      },
                      child: _buildBoxBook(context, mainData[index].id, mainData[index].title,
          mainData[index].thumbImage, mainData[index].publisher));
    },
                  )))


        ])


        ),

    );
  }


}