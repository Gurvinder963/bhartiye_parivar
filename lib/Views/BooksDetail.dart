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
import 'package:event_bus/event_bus.dart';
import 'privacyScreen.dart';
import '../Interfaces/OnCartCount.dart';
import '../Views/ViewOnlineBook.dart';
import '../Views/FullScreenGallery.dart';
import '../ApiResponses/BookDetailResponse.dart';
class BooksDetailPage extends StatefulWidget {
  final BookData content;


  BooksDetailPage({Key key,@required this.content}) : super(key: key);
  @override
  BooksDetailPageState createState() {
    return BooksDetailPageState(content);
  }
}

class BooksDetailPageState extends State<BooksDetailPage>  with TickerProviderStateMixin,WidgetsBindingObserver{
  TabController _tabcontroller;

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
  String cartCount='0';
  String user_Token;
  BooksDetailPageState(BookData content){
    mContent=content;
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('on_resumed_called');
    if (state == AppLifecycleState.resumed) {
      print('on_resumed_called');
      setCartCount();
    }
  }

  setCartCount() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      var user_Token=prefs.getString(Prefs.KEY_TOKEN);
      cartCount=prefs.getString(Prefs.CART_COUNT);
      setState(() {});

      setState(() {
        cartCount = cartCount;
      });


      return (prefs.getString('token'));
    });

  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _tabcontroller = new TabController(length: 3, vsync: this);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

       user_Token=prefs.getString(Prefs.KEY_TOKEN);
       cartCount=prefs.getString(Prefs.CART_COUNT);
       setState(() {});
       getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {

         setState(() {
           mContent=value.data;
        //   isLoading = false;
          // mainData.addAll(value.data);

         })

       });
       getBookRead(user_Token,mContent.id.toString()).then((value) => {});
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

  Future<BookDetailResponse> getBooksListDetail(String user_Token,String id) async {

    var body ={'lang_code':''};
    MainRepository repository=new MainRepository();
    return repository.fetchBooksDetailData(id,body,user_Token);

  }
  Future<AddToCartResponse> getBookRead(String user_Token,String book_id) async {
    var body =json.encode({"book_id":book_id,});

    MainRepository repository=new MainRepository();
    return repository.fetchReadBook(body,user_Token);

  }

  @override
  Widget build(BuildContext context) {


    //1 for printed
    //2 for e book

    String html;
    String url=mContent.embed_url;
    if(url.isNotEmpty && url.contains('youtube')) {
      var videoIdd;
      try {
        videoIdd = YoutubePlayer.convertUrlToId(url);
        print('this is ' + videoIdd);
      } on Exception catch (exception) {
        // only executed if error is of type Exception
        print('exception');
      } catch (error) {
        // executed for errors of all types other than Exception
        print('catch error');
        //  videoIdd="error";

      }
      html = '''
          <iframe id="ytplayer" style="border-left: 0px solid black;border-right: 0px solid black;" type="text/html" width="100%" height="100%"
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=1&enablejsapi=1"
  frameborder="1" allow="autoplay; encrypted-media" allowfullscreen></iframe>
     ''';

    }


    var shouldShowBadge=int.parse(cartCount)>0?true:false;
    bool isAddtoCartVisible=true;
   // bool isBuyNowVisible=true;
    bool isBuyNowVisibleEbook=true;
    bool goToCart=false;
    bool goToCartFromBuyNow=false;
    String btnText="ADD TO CART";
    var addtoCartBgColor=Color(AppColors.BaseColor);
    /*if(mContent.book_type_id==1 && mContent.is_printed_purchased){
      isAddtoCartVisible=false;
      isBuyNowVisible=false;
    }
    else*/
    if(mContent.book_type_id==2 && (mContent.is_ebook_purchased || mContent.ebook_cost==0)){
      isAddtoCartVisible=false;
      isBuyNowVisibleEbook=false;
    }
    else if(mContent.book_type_id==3 && mContent.is_ebook_purchased){
     // isAddtoCartVisible=false;
      isBuyNowVisibleEbook=false;
    }
   /* else if(mContent.book_type_id==3 && mContent.is_ebook_purchased ){
      isAddtoCartVisible=false;
      isBuyNowVisible=false;
    }*/

    if(mContent.book_type_id!=3 && (mContent.is_ebook_added_cart || mContent.is_printed_added_cart)){
      btnText="GO TO CART";
      goToCart=true;
      goToCartFromBuyNow=true;
      addtoCartBgColor=  Color(0xFF20d256);
    }
    else if(mContent.book_type_id==3 && (mContent.is_ebook_added_cart || mContent.is_printed_added_cart)){
      btnText="GO TO CART";
      goToCart=true;
      addtoCartBgColor=Color(0xFF20d256);
    }
    else if(mContent.book_type_id==3 && (mContent.is_ebook_added_cart && mContent.is_printed_added_cart)) {
      goToCartFromBuyNow=true;
    }
   /* else if(mContent.book_type_id==3 && (mContent.is_ebook_purchased && mContent.is_printed_added_cart)){
      btnText="GO TO CART";
      goToCart=true;
      addtoCartBgColor=Color(AppColors.ColorGreen);
    }*/

    if(mContent.book_type_id==3 &&  mContent.is_printed_added_cart && mContent.is_ebook_free){
      goToCartFromBuyNow=false;
    }

    if(mContent.book_type_id==4){
      isAddtoCartVisible=false;
     // isBuyNowVisibleEbook=false;
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

              Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MyCartPage();
                      }
                  )).then((_) {
                // This block runs when you have returned back to the 1st Page from 2nd.
                setCartCount();
                getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {

                  setState(() {
                    mContent=value.data;
                    //   isLoading = false;
                    // mainData.addAll(value.data);

                  })

                });
              });

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
                    height: MediaQuery.of(context).size.height / 3.5,
                  margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                  alignment: Alignment.center,
                 // height: ScreenUtil().setHeight(170),
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
          margin:  EdgeInsets.fromLTRB(0,10,0,0),
          child:Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child:
                    Container(child:
                mContent.book_type_id==2 || mContent.book_type_id==3|| mContent.book_type_id==4?
                Center(
                    child: Text(
                  'Online Book',
                  style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(14), color: Color(0xFF5a5a5a).withOpacity(0.8),fontWeight: FontWeight.w500),
                )):Container())),
                Expanded(
                    flex: 1,child:Container()),

                Expanded(
                    flex: 2,
                    child:
                    Container(child:  mContent.book_type_id==1 || mContent.book_type_id==3|| mContent.book_type_id==4?
                    Center(
                        child:Text(
                  'Printed Book',
                  style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(14), color: Color(0xFF5a5a5a).withOpacity(0.8),fontWeight: FontWeight.w500),
                )):Container())),
              ]))

                ,
                Container(
                    margin:  EdgeInsets.fromLTRB(0,10,0,0),
                    child:Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Expanded(
                        flex: 2,
                        child:
                         Container(child:
                          mContent.book_type_id==2 || mContent.book_type_id==3?
                          Center(
                            child:  Text(
                            mContent.ebook_cost==0?"Free":'₹ ' +mContent.ebook_cost.toString()+'/-',
                            style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(18), color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold),
                          )):mContent.book_type_id==4?  Center(
                              child: Text("Unavailable",
                            style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(18), color: Colors.red.withOpacity(0.8),fontWeight: FontWeight.bold),
                          )):Container())),
                    Expanded(
                        flex: 1,child:Container()),

                          Expanded(
                              flex: 2,
                              child:
                              Container(child:
                          mContent.book_type_id==1 || mContent.book_type_id==3?
                          Center(
                            child:  Text(
                            '₹ ' +mContent.cost.toString()+'/-',
                            style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(18), color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold),
                          )):mContent.book_type_id==4? Center(
                              child:  Text("Out of Stock",
                            style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(18), color: Colors.red.withOpacity(0.8),fontWeight: FontWeight.bold),
                          )):Container(),))

                        ]))

                ,
                Container(
                    margin:  EdgeInsets.fromLTRB(3,10,0,0),
                    child:Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child:
                              Container(
                                  child:Column(

                                  children: <Widget>[
                                    mContent.book_type_id!=4 && ((mContent.is_ebook_purchased || mContent.ebook_cost==0)&& mContent.book_type_id!=1) ?
                                    _ReadNowButton(mContent.id,mContent.ebook_cost): Container(),


                                    mContent.book_type_id!=4 && (!mContent.is_ebook_purchased && mContent.ebook_cost!=0 && (mContent.book_type_id==2 ||mContent.book_type_id==3))?
                                    _buyNowButtonEbook(goToCartFromBuyNow):Container(),


                                  ]))),

                          Expanded(
                              flex: 1,child:Container()),
                          Expanded(
                              flex: 2,
                              child:
                              Container(child:
                         Center(child: mContent.book_type_id!=4 && mContent.book_type_id!=2?
                          _buyNowButtonPrinted(goToCartFromBuyNow):Container()))),


                        ]))
             ,
                SizedBox(height: 10),
                PreferredSize(

                  preferredSize: Size.fromHeight(50.0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0,6,0,8),
                      color: Color(0xFF494949),
                      child:TabBar(
                        controller: _tabcontroller,
                    labelColor: Colors.black,

                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 2,

                        indicatorColor: Colors.orange,
                    tabs: [
                        SizedBox(
                        height: 32,
                      child:Tab(
                        child: Text("Description",
                            style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(15), color:  isDescription?Color(0xFFffa500).withOpacity(1):Color(0xFFffffff),fontWeight: FontWeight.w500)),
                      )),
                      SizedBox(
                        height: 32, child:Tab(
                        child: Text("Photos",
                            style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(15), color:  isDescription?Color(0xFFffa500).withOpacity(1):Color(0xFFffffff),fontWeight: FontWeight.w500)),
                      )),
                      SizedBox(
                        height: 32,child:Tab(
                        child: Text("Offers",
                            style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(15), color:  isDescription?Color(0xFFffa500).withOpacity(1):Color(0xFFffffff),fontWeight: FontWeight.w500)),
                      ))
                    ], // list of tabs
                  )),
                ),
             /*   Divider(

                  height: 6,

                  thickness: 6,
                  color: Color(0xFF494949),
                ),*///TabBarView(children: [ImageList(),])
                Container(
                  height: 1000.0,
                  child: TabBarView(
                    controller: _tabcontroller,
                    children: [
                      Container(

                        child:   Padding(
                  padding: EdgeInsets.fromLTRB(20,20,20,100),
                  child:Text(
                          mContent.description,
                          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(16), color:  Color(0xFF5a5a5a).withOpacity(0.8),fontWeight: FontWeight.w500),
                        )),
                      ),
    Column(

    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10,10,10,10),
                        child: SizedBox(
                           child: GridView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: mContent.images.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.0,
                                  childAspectRatio: (2 / 3),
                                  mainAxisSpacing: 4.0
                              ),
                              itemBuilder: (BuildContext context, int index){
                                return  GestureDetector(
                                    onTap: () =>
                                {

                                  Navigator.of(context, rootNavigator: true)
                                      .push( // ensures fullscreen
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return FullScreenGalleryPage(content: mContent,mIndex:index);
                                          }
                                      )).then((_) {})
                                },child:Container(
                                  margin: EdgeInsets.fromLTRB(0.0,8.0,0.0,0.0),

                                  alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(mContent.images[index]),
                                    ),
                                  ),

                                ));
                              },
                            )),
                      ), url==''?Container():Container(
       padding: EdgeInsets.fromLTRB(10.0,20.0,10.0,10.0),


       child:  HtmlWidget(

            html,
            webView: true,
          )
      ),

    ]),
                      Container(

                        child:   Padding(
    padding: EdgeInsets.fromLTRB(20,20,20,100),
    child:Text(mContent.is_ebook_free?"If you buy a printed book you can also read the book online.\n\n if you buy in bulk to distribute, \n contact 8876873456":"No Offer",
                            style: GoogleFonts.poppins( fontSize: ScreenUtil().setSp(16), color: Color(0xFF5a5a5a),fontWeight: FontWeight.w500))),
                      ) // class name
                    ],
                  ),
                ),

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
            )).then((_) {
          // This block runs when you have returned back to the 1st Page from 2nd.
          setCartCount();
          getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {

            setState(() {
              mContent=value.data;
              //   isLoading = false;
              // mainData.addAll(value.data);

            })

          });
        });
      }
      else {
        if (mContent.book_type_id == 3) {

    /*      if(mContent.is_ebook_added_cart || mContent.is_printed_added_cart){


            if(mContent.is_ebook_added_cart){
              addToCartAPI("1", false);
            }
            else if(mContent.is_printed_added_cart){
              addToCartAPI("2", false);
            }



          }
          else{*/
           /* if(mContent.is_printed_purchased){
              addToCartAPI("2", false);
            }*/

             if(mContent.is_ebook_purchased){
              addToCartAPI("1", false);
            }
            else{
              showDialogCart(false);
            }


        //  }
        }
        else {
          addToCartAPI(mContent.book_type_id.toString(), false);
        }
      }


    },child:Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: addtoCartBgColor,
              padding: EdgeInsets.fromLTRB(0,8,0,8),
              child: Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child:  Text(btnText,

                  style: GoogleFonts.poppins( letterSpacing: 1.2,fontSize: ScreenUtil().setSp(16), color:  Color(0xFFffffff),fontWeight: FontWeight.w500),),
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
                  Navigator.pop(context);
                  addToCartAPI("2",isBuyNow);
                },

                child: Container(
                  width: 250,
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(1)),
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
                    'Online Book',
                    style: GoogleFonts.poppins(
                        fontSize: ScreenUtil().setSp(18),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Text("OR"),

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  addToCartAPI("1",isBuyNow);
                },

                child: Container(
                  width: 250,
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  padding: EdgeInsets.symmetric(vertical: 5),
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
                    'Printed Book',
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
      eventBus.fire(OnCartCount("FIND"));

      if(book_type_id=='1'){
        mContent.is_printed_added_cart=true;
      }
      else if(book_type_id=='2'){
        mContent.is_ebook_added_cart=true;
      }
      setState(() {
       cartCount=(int.parse(cartCount)+1).toString();
      });
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
            )).then((_) {
          // This block runs when you have returned back to the 1st Page from 2nd.

          getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {

            setState(() {
              mContent=value.data;
              //   isLoading = false;
              // mainData.addAll(value.data);

            })

          });
        });
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



  Future<AddToCartResponse> postAddToMyBooks(String book_id,String token) async {

    print('my_token'+token);
    var body =json.encode({"book_id":book_id,"book_type_id":"2","order_id":"-1","payment_status":"success","quantity":"1"});
    MainRepository repository=new MainRepository();
    return repository.fetchAddMyBooksData(body,token);

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

  Widget _buyNowButtonEbook(bool goToCart) {
    return InkWell(
      onTap: () {
        if(goToCart){
          Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MyCartPage();
                  }
              )).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.

            getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {

              setState(() {
                mContent=value.data;
                //   isLoading = false;
                // mainData.addAll(value.data);

              })

            });
          });
        }
        else if(mContent.is_printed_added_cart && mContent.is_ebook_free){
          Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MyCartPage();
                  }
              )).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.

            getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {

              setState(() {
                mContent=value.data;
                //   isLoading = false;
                // mainData.addAll(value.data);

              })

            });
          });
        }
        else {
          if(mContent.is_ebook_added_cart){
            Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MyCartPage();
                    }
                )).then((_) {

              getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {
                setState(() {
                  mContent=value.data;})
              });
            });
          }
          else{
            addToCartAPI("2", true);
          }
        }
      },

      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0,0,10,10),
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
                colors: [Colors.orange, Colors.orange])),
        child: Text(
          'BUY NOW',
          style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(16), color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
  Widget _buyNowButtonPrinted(bool goToCart) {
    return InkWell(
      onTap: () {
        if(goToCart){
          Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MyCartPage();
                  }
              )).then((_) {

            getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {
              setState(() {
                mContent=value.data;})
            });
          });
        }
        else {

         if(mContent.is_printed_added_cart){
           Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
               MaterialPageRoute(
                   builder: (BuildContext context) {
                     return MyCartPage();
                   }
               )).then((_) {

             getBooksListDetail(user_Token,mContent.id.toString()).then((value) => {
               setState(() {
                 mContent=value.data;})
             });
           });
         }
         else{
           addToCartAPI("1", true);
         }





        }
      },

      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0,0,10,10),
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
                colors: [Color(0xFFff0000), Color(0xFFff0000)])),
        child: Text(
          'BUY NOW',
          style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(16), color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _ReadNowButton(int booksid,int ebookCost) {
    return InkWell(
      onTap: () {

        if(ebookCost==0){
          setState(() {
            _isInAsyncCall = true;
          });

          postAddToMyBooks(booksid.toString(),user_Token)
              .then((res) async {
            setState(() {
              _isInAsyncCall = false;
            });
            Navigator.of(context, rootNavigator: true)
                .push( // ensures fullscreen
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ViewOnlineBookPage();
                    }
                ));

          });
        }
        else {
          Navigator.of(context, rootNavigator: true)
              .push( // ensures fullscreen
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ViewOnlineBookPage();
                  }
              ));
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
                colors: [Color(0xFF20d256), Color(0xFF20d256)])),
        child: Text(
          'READ NOW',
          style: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(16), color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

}