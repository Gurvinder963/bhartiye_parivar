import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ApiResponses/BookData.dart';
import '../Repository/MainRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/AddToCartResponse.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import '../Views/MyCart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';
class BooksDetailPage extends StatefulWidget {
  final BookData content;


  BooksDetailPage({Key key,@required this.content}) : super(key: key);
  @override
  BooksDetailPageState createState() {
    return BooksDetailPageState(content);
  }
}

class BooksDetailPageState extends State<BooksDetailPage> {
  YoutubePlayerController _controller;
  final List<String> _ids = [];
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  bool isDescription=true;
  bool isPhotos=false;
  bool isOffers=false;
  BookData mContent;
  bool _isInAsyncCall = false;

  String user_Token;
  BooksDetailPageState(BookData content){
    mContent=content;
  }

  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

       user_Token=prefs.getString(Prefs.KEY_TOKEN);

      return (prefs.getString('token'));
    });

  }




  @override
  Widget build(BuildContext context) {

    bool isAddtoCartVisible=true;
    bool isBuyNowVisible=true;
    bool goToCart=false;
    String btnText="ADD TO CART";

    if(mContent.book_type_id!=3 && (mContent.is_ebook_purchased || mContent.is_printed_purchased)){
      isAddtoCartVisible=false;
      isBuyNowVisible=false;
    }
    else if(mContent.book_type_id==3 && (mContent.is_ebook_purchased && mContent.is_printed_purchased)){
      isAddtoCartVisible=false;
      isBuyNowVisible=false;
    }

    if(mContent.book_type_id!=3 && (mContent.is_ebook_added_cart || mContent.is_printed_added_cart)){
      btnText="GO TO CART";
      goToCart=true;
    }
    else if(mContent.book_type_id==3 && (mContent.is_ebook_added_cart && mContent.is_printed_added_cart)){
      btnText="GO TO CART";
      goToCart=true;
    }

    final height = MediaQuery.of(context).size.height;
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('Details', style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),
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
            position: BadgePosition.topEnd(top: 0, end: -4),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent: Text('3',
                style: GoogleFonts.poppins(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w500)),
            child: Icon(Icons.shopping_cart,color: Colors.white,size: 26,),
          ),
          ),
          SizedBox(
            width: 20,
          ),

        ],
      ),

      body:   ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:Stack(  children: [ SingleChildScrollView (
    child:Container(

          child:Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[

                Container(

                  margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(170),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(mContent.back_image),

                      alignment: Alignment.center,
                    ),

                  ),

                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15,20,0,0),
                    child:
                    Text(
                      mContent.title,
                      style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.black,fontWeight: FontWeight.w500),
                    ),),



      Container(
          margin:  EdgeInsets.fromLTRB(20,10,20,0),
          child:Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                mContent.book_type_id==2 || mContent.book_type_id==3?
                Text(
                  'Online Book',
                  style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(14), color: Color(0xFF5a5a5a).withOpacity(0.8),fontWeight: FontWeight.w500),
                ):Container(),
                Spacer(),
                mContent.book_type_id==1 || mContent.book_type_id==3?
                Text(
                  'Printed Book Price',
                  style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(14), color: Color(0xFF5a5a5a).withOpacity(0.8),fontWeight: FontWeight.w500),
                ):Container(),
              ]))

                ,
                Container(
                    margin:  EdgeInsets.fromLTRB(20,10,20,0),
                    child:Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          mContent.book_type_id==2 || mContent.book_type_id==3?
                          Text(
                            '₹ ' +mContent.ebook_cost.toString()+'/-',
                            style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(18), color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold),
                          ):Container(),
                          Spacer(),
                          mContent.book_type_id==1 || mContent.book_type_id==3?
                          Text(
                            '₹ ' +mContent.cost.toString()+'/-',
                            style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(18), color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold),
                          ):Container(),
                          SizedBox(width: 30),
                        ]))

                ,
                Container(
                    margin:  EdgeInsets.fromLTRB(20,10,10,0),
                    child:Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //_DonateButton(),

                        Spacer(),
                          isBuyNowVisible?
                          _joinButton(goToCart):Container(),


                        ]))
             ,
              Container(
                    alignment: FractionalOffset.center,
                  padding:  EdgeInsets.fromLTRB(0,8,0,8),
                    margin:  EdgeInsets.fromLTRB(0,20,0,0),
                    color: Color(0xFF494949),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Container(
                             child: Expanded(
                        flex: 1,

                                  child:
    GestureDetector(
    onTap: () {
      setState(() {
        isDescription = true;
        isPhotos=false;
        isOffers=false;

      });

    },child: Column(

                                  children: <Widget>[
                                    Text("Description",
                                        style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(16), color:  isDescription?Color(0xFFffa500).withOpacity(1):Color(0xFFffffff),fontWeight: FontWeight.w500)),
                                    isDescription?  Padding(
                                     padding: EdgeInsets.fromLTRB(40,0,40,0),
                                     child: Divider(

                                height: 1,

                                thickness: 1,
                                color: Colors.orange,
                              )):Container(),

                                  ]))))
                         , Container(
                              child:Expanded(
                                  flex: 1,

                         child: GestureDetector(
                             onTap: () {
                               setState(() {
                                 isDescription = false;
                                 isPhotos=true;
                                 isOffers=false;

                               });

                             },child:Column(

                                  children: <Widget>[
                                    Text("Photos",
                                        style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(16), color: isPhotos?Color(0xFFffa500).withOpacity(1):Colors.white,fontWeight: FontWeight.w500)),

                                 isPhotos? Padding(
                                      padding: EdgeInsets.fromLTRB(40,0,40,0),
                                      child:  Divider(

                                      height: 1,

                                      thickness: 1,
                                      color: Colors.orange,
                                    )):Container(),
                                  ]))))
                          ,Container(
                              child:Expanded(
                                  flex: 1,
                                  child:GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isDescription = false;
                                          isPhotos=false;
                                          isOffers=true;

                                        });

                                      },
                          child:Column(

                                  children: <Widget>[
                                    Text("Offers",
                                        style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(16), color: isOffers?Color(0xFFffa500).withOpacity(1):Colors.white,fontWeight: FontWeight.w500)),
                                isOffers? Padding(
                                      padding: EdgeInsets.fromLTRB(40,0,40,0),
                                      child:   Divider(

                                      height: 1,

                                      thickness: 1,
                                      color: Colors.orange,
                                    )):Container(),

                                  ])))),

                        ]))
                ,

                Padding(
                  padding: EdgeInsets.fromLTRB(20,20,20,100),
                  child:
                  isDescription?Text(
                    mContent.description,
                    style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(16), color:  Color(0xFF5a5a5a).withOpacity(0.8),fontWeight: FontWeight.w500),
                  ):isPhotos?    SizedBox(
                      child: GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
    itemCount: mContent.images.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.0,
        childAspectRatio: (1 / 1.7),
        mainAxisSpacing: 4.0
    ),
    itemBuilder: (BuildContext context, int index){
    return  Container(
      margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

      alignment: Alignment.center,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(mContent.images[index]),
        ),
      ),

    );
    },
    )):Text("If you buy a printed book you can also read the book online.\n\n if you buy in bulk to distribute, \n contact 8876873456",
                      style: GoogleFonts.poppins( fontSize: ScreenUtil().setSp(16), color: Color(0xFF5a5a5a),fontWeight: FontWeight.w500)),),


              ])

      )),
      isAddtoCartVisible?Align(
            alignment: FractionalOffset.bottomCenter,
            child:    GestureDetector(
    onTap: () {

      if(goToCart){
        Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return MyCartPage();
                }
            ));
      }
      else {
        if (mContent.book_type_id == 3) {

          if(mContent.is_ebook_added_cart || mContent.is_printed_added_cart){


            if(mContent.is_ebook_added_cart){
              addToCartAPI("1", false);
            }
            else if(mContent.is_printed_added_cart){
              addToCartAPI("2", false);
            }



          }
          else{

          showDialogCart(false);
          }
        }
        else {
          addToCartAPI(mContent.book_type_id.toString(), false);
        }
      }


    },child:Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Color(AppColors.BaseColor),
              padding: EdgeInsets.fromLTRB(0,8,0,8),
              child: Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child:  Text(btnText,

                  style: GoogleFonts.poppins( letterSpacing: 1.2,fontSize: ScreenUtil().setSp(16), color:  Color(0xFFffffff).withOpacity(0.8),fontWeight: FontWeight.w500),),
              ),


            )),
          ):Container(),
        ])),

    );
  }

  void showDialogCart(bool isBuyNow){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  addToCartAPI("2",isBuyNow);
                },

                child: Container(
                  width: 150,
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
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
                          colors: [
                            Color(AppColors.BaseColor),
                            Color(AppColors.BaseColor)
                          ])),
                  child: Text(
                    'E-Book',
                    style: GoogleFonts.poppins(
                        fontSize: ScreenUtil().setSp(18),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Text("----or----"),

              InkWell(
                onTap: () {
                  addToCartAPI("1",isBuyNow);
                },

                child: Container(
                  width: 150,
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
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
                          colors: [
                            Color(AppColors.BaseColor),
                            Color(AppColors.BaseColor)
                          ])),
                  child: Text(
                    'Printed',
                    style: GoogleFonts.poppins(
                        fontSize: ScreenUtil().setSp(18),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }


void addToCartAPI(String book_type_id,bool isBuyNow){

  setState(() {
    _isInAsyncCall = true;
  });

  postAddToCart(mContent.id.toString(),user_Token,book_type_id)
      .then((res) async {
    setState(() {
      _isInAsyncCall = false;
    });


    if (res.status == 1) {
      Fluttertoast.showToast(
          msg: "Item added to cart !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      if(isBuyNow) {
        Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return MyCartPage();
                }
            ));
      }
    }
    else {
      showAlertDialogValidation(context,"Some error occured!");
    }
  });
}

  Future<AddToCartResponse> postAddToCart(String book_id,String token,String book_type_id) async {

    print('my_token'+token);
    var body =json.encode({"book_id":book_id,"book_type_id":book_type_id});
    MainRepository repository=new MainRepository();
    return repository.fetchAddCartData(body,token);

  }

  showAlertDialogValidation(BuildContext context,String message) {

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Constants.AppName),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
  Widget _joinButton(bool goToCart) {
    return InkWell(
      onTap: () {
        if(goToCart){
          Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MyCartPage();
                  }
              ));
        }
        else {
          if (mContent.book_type_id == 3) {

            if(mContent.is_ebook_added_cart || mContent.is_printed_added_cart){


              if(mContent.is_ebook_added_cart){
                addToCartAPI("1", true);
              }
              else if(mContent.is_printed_added_cart){
                addToCartAPI("2", true);
              }



            }
            else {
              showDialogCart(true);
            }
          }
          else {
            addToCartAPI(mContent.book_type_id.toString(), true);
          }

        }
      },

      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0,0,0,10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(

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
                colors: [Colors.red, Colors.red])),
        child: Text(
          'BUY NOW',
          style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(16), color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _DonateButton() {
    return InkWell(
      onTap: () {

      },

      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0,0,0,10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(

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
                colors: [Color(0xFF20d256), Color(0xFF20d256)])),
        child: Text(
          'READ NOW',
          style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(16), color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

}