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

class BooksPage extends StatefulWidget {
  @override
  BooksPageState createState() {
    return BooksPageState();
  }
}

class BooksPageState extends State<BooksPage> {
  List mainData = new List();
  bool isLoading = false;

  String user_Token;
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

    var body ={'lang_code':''};
    MainRepository repository=new MainRepository();
    return repository.fetchBooksData(body,user_Token);

  }
  Widget _buildBoxBook(BuildContext context,int id,String title,String thumbnail,String publisher,int ebookCost,bool isEbookPurchased,bool isPrinterPurchased, int book_type_id ){

    bool greenTick=false;
    if((ebookCost==0 && book_type_id==2)|| isEbookPurchased || isPrinterPurchased){
      greenTick=true;
    }

    return    SizedBox( child: Container(
        margin:EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0) ,

        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
    child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[

    AspectRatio(
    aspectRatio: 2 / 3,
        child:
        Stack(
            alignment: Alignment.center,
            children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

        alignment: Alignment.center,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(thumbnail),
          ),
        ),

      ),
              greenTick?Positioned(
            top: 0.0,
            right: 0.0,
            child:
              Image(
                image: new AssetImage("assets/green_tick.png"),

                height:  25,
                width:  25,

                fit: BoxFit.fill,
                alignment: Alignment.center,
              )):Container()

            ])),
        Padding(
            padding: EdgeInsets.fromLTRB(0,4,0,0),
            child:
      Text(title,   overflow: TextOverflow.ellipsis,
        maxLines: 1, style: GoogleFonts.roboto(
          fontSize:13.0,
          color: Color(0xFF1f2833).withOpacity(1),

        ),)),

        Padding(
            padding: EdgeInsets.fromLTRB(0,2,0,0),
            child: Text(publisher,   overflow: TextOverflow.ellipsis,
        maxLines: 1, style: GoogleFonts.roboto(
        fontSize:11.0,
        color: Color(0xFF5a5a5a),

    ),)),
    ])));
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

    return Scaffold(

        body: Container(
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          padding:  EdgeInsets.fromLTRB(1,8,1,0),
        child: ListView(
       // crossAxisAlignment: CrossAxisAlignment.start,
        children: [



        Container(
          height: MediaQuery.of(context).size.height*0.23,
        child:
          Row(

             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 8),
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
        Opacity(
        opacity: 0.7,
        child:  Container(
            margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

            alignment: Alignment.center,
            // height: ScreenUtil().setHeight(175),

            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage("assets/ic_new_my_books.png"),

                alignment: Alignment.center,
              ),

            ),

          ))
    /*    Opacity(
        opacity: 0.8,
        child: Image(
                    image: new AssetImage("assets/ic_new_my_books.png"),



                    fit: BoxFit.fill,

                  )),*/

        /*  Container(

            padding:  EdgeInsets.symmetric(vertical: 7,horizontal: 8),
              decoration: BoxDecoration(
                  color:Colors.black.withOpacity(0.6) ,

                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child:Text("MY BOOKS"
                ,style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white,fontWeight: FontWeight.w500),),
          ),*/

        ])),
                ),
                SizedBox(width: 8),
                Expanded(
                  child:  GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return BookGroupListPage();
                          }
                      ) );
                },

                child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                    Opacity(
                    opacity: 0.7,
                    child:
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                          alignment: Alignment.center,
                          // height: ScreenUtil().setHeight(175),

                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/ic_by_lang.png"),

                              alignment: Alignment.center,
                            ),

                          ),

                        ))
               /*         Opacity(
                            opacity: 0.8,
                            child:  Image(
                              image: new AssetImage("assets/ic_by_lang.png"),



                              fit: BoxFit.fill,

                            ),
                        )

,*/
                    /*   Container(
                          padding:  EdgeInsets.symmetric(vertical: 7,horizontal: 8),
                          decoration: BoxDecoration(
                              color:Colors.black.withOpacity(0.6) ,

                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child:Text("BY LANGUAGE",style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white,fontWeight: FontWeight.w500),),
                        ),*/

                      ])),
                ),
                SizedBox(width: 8),

              ]

          )),
    Padding(
    padding: EdgeInsets.fromLTRB(10,10,10,10),
          child:
          Text("All Books",style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(20), color: Colors.black,fontWeight: FontWeight.w500),)
    )
,

            Padding(
                    padding: EdgeInsets.fromLTRB(8,0,8,0),

                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: mainData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.0,
                        childAspectRatio: (2 / 4),
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
            )).then((_) {


          // This block runs when you have returned back to the 1st Page from 2nd.
     /*     setState(() {
        mainData.clear();
          });
        getBooksList(user_Token).then((value) => {

          setState(() {
            isLoading = false;
            mainData.addAll(value.data);

          })

        });*/
          })
      },
                      child: _buildBoxBook(context, mainData[index].id, mainData[index].title,
          mainData[index].thumbImage, mainData[index].publisher,mainData[index].ebook_cost,mainData[index].is_ebook_purchased,mainData[index].is_printed_purchased,mainData[index].book_type_id));
    },
                  ))


        ])


        ),

    );
  }


}