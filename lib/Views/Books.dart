import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyBooksTab.dart';
import 'BooksByLanguage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Repository/MainRepository.dart';
import 'BooksDetail.dart';
import'../ApiResponses/BookListResponse.dart';
import '../Views/BookGroupList.dart';
import '../localization/locale_constant.dart';
class BooksPage extends StatefulWidget {
  @override
  BooksPageState createState() {
    return BooksPageState();
  }
}

class BooksPageState extends State<BooksPage> {
  List mainData = new List();
  bool isLoading = false;
  bool _isInAsyncCall = false;
  String user_Token;
  int page = 1;
  ScrollController _sc = new ScrollController();
  @override
  void dispose() {

    _sc.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

       user_Token=prefs.getString(Prefs.KEY_TOKEN);
       apiCall();


      return (prefs.getString('token'));
    });
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        apiCall();
      }
    });

  }

  void apiCall(){

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });}

    getLocaleContentLang().then((locale) {

      if(locale==null){
        locale="";
      }
     if(page==1) {
       setState(() {
         _isInAsyncCall = true;
       });
     }
      getBooksList(user_Token,locale).then((value) => {

        setState(() {
          isLoading = false;
          _isInAsyncCall = false;
          mainData.addAll(value.data);
          if (!mainData.isEmpty) {
            page++;
          }
        })

      });
    });

  }

  Future<BookListResponse> getBooksList(String user_Token,String locale) async {
    String pageIndex = page.toString();
    String perPage = "10";
    var body ={'lang_code':locale, 'page': pageIndex,
      'per_page': perPage,};
    MainRepository repository=new MainRepository();
    return repository.fetchBooksData(body,user_Token);

  }
  Widget _buildBoxBook(BuildContext context,bool isBookRead,int id,String title,String thumbnail,String publisher,int ebookCost,bool isEbookPurchased,bool isPrinterPurchased, int book_type_id ){

    bool greenTick=false;
    if((ebookCost==0 && book_type_id==2)|| isEbookPurchased || isPrinterPurchased){
      greenTick=true;
    }

    return    SizedBox( child: Container(
        margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,

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
              isBookRead?Container(): Positioned(
                  top: 0.0,
                  left: 0.0,
                  child:
                  Image(
                    image: new AssetImage("assets/ic_new.png"),

                    height:  33,
                    width:  33,

                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  )),
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
        fontSize:12.0,
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

  Widget centerText(){
    return   Padding(
        padding: EdgeInsets.fromLTRB(10,10,10,10),
        child:
        Text("All Books",style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(20), color: Colors.black,fontWeight: FontWeight.w500),)
    );

  }

  Widget bottomView(){
    return
      Padding(
          padding: EdgeInsets.fromLTRB(8,0,8,0),

          child: GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: mainData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.0,
                childAspectRatio: (2 / 3.7),
                mainAxisSpacing: 4.0
            ),
            itemBuilder: (BuildContext context, int index){

              return GestureDetector(
                  onTap: () =>
                  {

                    setState(() {
                      mainData[index].is_read_book=true;
                    }),
                    Navigator.of(context, rootNavigator: true)
                        .push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return BooksDetailPage(content: mainData[index]);
                            }
                        )).then((_) {



                    })
                  },
                  child: _buildBoxBook(context, mainData[index].is_read_book,mainData[index].id, mainData[index].title,
                      mainData[index].thumbImage, mainData[index].publisher,mainData[index].ebook_cost,mainData[index].is_ebook_purchased,mainData[index].is_printed_purchased,mainData[index].book_type_id)


              );}
            ,
          )
      );

  }


  Widget topHeader(){
    return Container(
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


                        ])),
              ),
              SizedBox(width: 8),

            ]

        ));




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

        body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.01,
        progressIndicator: CircularProgressIndicator(),
    child:Container(
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          padding:  EdgeInsets.fromLTRB(1,8,1,0),
        child:
    ListView.builder(
    itemCount: 3 , // Add one more item for progress indicator
        controller: _sc,
    itemBuilder: (BuildContext context, int index) {


      if(index==0){
        return topHeader();
      }
      else if(index==1){
        return centerText();
      }
      else if(index==2){
        return bottomView();
      }

    })




        )),

    );
  }


}