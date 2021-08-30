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
import '../Interfaces/OnCartCount.dart';
import 'package:badges/badges.dart';
import '../Views/MyCart.dart';
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
  String cartCount='0';
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
      cartCount=prefs.getString(Prefs.CART_COUNT);
      setState(() {});



      return (prefs.getString('token'));
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


  Widget _buildBoxBook(BuildContext context,int id,String title,String thumbnail,String publisher,int ebookCost,bool isEbookPurchased,bool isPrinterPurchased, int book_type_id){

    bool greenTick=false;
    if((ebookCost==0 && book_type_id==2)|| isEbookPurchased || isPrinterPurchased){
      greenTick=true;
    }


    return SizedBox( child:Container(
        margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
      //  height: 175,
        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10))
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
        title: Text(mName+ " Books", style: GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 23,color: Color(0xFFFFFFFF))),
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
                                            return BooksDetailPage(content: mBookArray[index]);
                                          }
                                      ))
                                },
                                child: _buildBoxBook(context, mBookArray[index].id, mBookArray[index].title,
                                    mBookArray[index].thumbImage, mBookArray[index].publisher,mBookArray[index].ebook_cost,mBookArray[index].is_ebook_purchased,mBookArray[index].is_printed_purchased,mBookArray[index].book_type_id));
                          },
                        )))


              ])


      ),

    );
  }


}