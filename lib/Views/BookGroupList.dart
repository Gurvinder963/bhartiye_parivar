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
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import'../ApiResponses/BookGroupListResponse.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ApiResponses/BookData.dart';
import '../localization/locale_constant.dart';
import '../Views/SeeALLBooks.dart';
import 'package:badges/badges.dart';
import '../Views/MyCart.dart';
import '../Interfaces/OnCartCount.dart';
class BookGroupListPage extends StatefulWidget {
  @override
  BookGroupListPageState createState() {
    return BookGroupListPageState();
  }
}

class BookGroupListPageState extends State<BookGroupListPage> {
  List mainData = new List();
  bool isLoading = false;
  String cartCount='0';
  ScrollController _sc = new ScrollController();
  @override
  void initState() {
    super.initState();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      var user_Token=prefs.getString(Prefs.KEY_TOKEN);
      cartCount=prefs.getString(Prefs.CART_COUNT);
      setState(() {});
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}
      getLocaleContentLang().then((locale) {

        if(locale==null){
          locale="";
        }
      getBooksList(user_Token,locale).then((value) => {

        setState(() {
          isLoading = false;
          mainData.addAll(value.data);

        })

      });
      });

      return (prefs.getString('token'));
    });
    _sc.addListener(() {
      if (_sc.position.pixels ==
          _sc.position.maxScrollExtent) {
       // _getMoreData(page,tok,-1);
      }
    });
    eventBus.on<OnCartCount>().listen((event) {

      Future.delayed(const Duration(milliseconds: 2000), () {
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        Future<String> token;
        token = _prefs.then((SharedPreferences prefs) {

          var user_Token=prefs.getString(Prefs.KEY_TOKEN);
          cartCount=prefs.getString(Prefs.CART_COUNT);
          setState(() {});
          return (prefs.getString('token'));
        });      });



    });
  }
  @override
  void dispose() {

    _sc.dispose();
    super.dispose();
  }
  Future<BookGroupListResponse> getBooksList(String user_Token, String locale) async {

    var body ={'lang_code':locale};
    MainRepository repository=new MainRepository();
    return repository.fetchBooksGroupData(body,user_Token);

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
    var shouldShowBadge=int.parse(cartCount)>0?true:false;
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
        title: Text('By Language', style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),
        actions: <Widget>[


          GestureDetector(
            onTap: () {

              Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MyCartPage();
                      }
                  ) );

            },child:
          Badge(
            showBadge: shouldShowBadge,
            position: BadgePosition.topEnd(top: 0, end: -4),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent: Text(cartCount,
                style: GoogleFonts.poppins(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w500)),
            child: Icon(Icons.shopping_cart,color: Colors.white,size: 26,),
          ),
          ),
          SizedBox(
            width: 20,
          ),

        ],
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(4,0,0,0),
          padding:  EdgeInsets.symmetric(horizontal: 5),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: SizedBox(

                    child: _buildList(),
                  ),
                )


              ])


      ),

    );
  }
  Widget _buildList() {
    return ListView.builder(
      itemCount: mainData.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {
          return GestureDetector(
            onTap: () => {

            },
            child:  _buildBox(context,mainData[index]),

          );
        }
      },
      controller: _sc,
    );
  }

  Widget _buildBox(BuildContext context,Data content){
    double c_width = MediaQuery.of(context).size.width*0.8;
    return  Container(decoration: BoxDecoration(


    ),

      child:Align(alignment: Alignment.topLeft,
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[


            Row(
              children: <Widget>[
                Container (
                    width: c_width,
                    child:Padding(
                      padding: EdgeInsets.fromLTRB(10,10,20,0),
                      child:  Text(content.langName+" books", textAlign: TextAlign.left,
                          style:  GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18,color: Color(0xff1f2833))),
                    )),

                Spacer(),
                new GestureDetector(
                    onTap: (){

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                          MaterialPageRoute(
                              builder: (BuildContext context) {
                                return SeeALLBooksPage(bookArray:content.books,name:content.langName);
                              }
                          ) );


                    },

                    child: Container(
                      margin: const EdgeInsets.only(top:15, right: 10.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text("See All", style: TextStyle( fontSize: 14,color: Color(0xff666666))),
                      ),

                    )),
              ],
            ),



           _horizontalListView(content.langName,content.books),

          /*  Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 0.5,
                color:Color(0xff666666),
              ),
            ),
*/
          ])),);


  }

  Widget _horizontalListView(String title,List<BookData> bookList) {
    return SizedBox(
       height: 250,
        child: ListView.builder(
          itemCount: bookList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () => {

              Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return BooksDetailPage(content: bookList[index]);
                      }
                  ) )

            },
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                margin:EdgeInsets.fromLTRB(0, 10, 7, 0) ,
                width: 130,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    _buildBoxItem(bookList[index].title,bookList[index].thumbImage,bookList[index]),

                    SizedBox(height: 5),
                    _buildText(bookList[index].title),

                    _buildTextPublisher(bookList[index].publisher),

                  ],
                )

            ),


          ),
        ));
  }
  Widget _buildText(String title){
    final text = title;
    return Text( text,overflow: TextOverflow.ellipsis,
        maxLines: 1,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12));


  }
  Widget _buildTextPublisher(String title){
    final text = title;
    return Text( text,overflow: TextOverflow.ellipsis,
        maxLines: 1,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 10));


  }
  Widget _buildBoxItem(String title,String thumbnail, BookData bookData){
    var divwidth=MediaQuery.of(context).size.width*.20+50;
    print("my_divwidth"+divwidth.toString());
    bool greenTick=false;
    if((bookData.ebook_cost==0 && bookData.book_type_id==2)|| bookData.is_ebook_purchased || bookData.is_printed_purchased){
      greenTick=true;
    }
    return    Stack(
      alignment: Alignment.center,
      children: <Widget>[

    Container(
          margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
        height: 190,
        width: 130,
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

      ],
    );}
}


