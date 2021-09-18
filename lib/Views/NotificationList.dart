import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../Views/ViewOnlineBook.dart';
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
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/OrderResponse.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'privacyScreen.dart';
import 'VideoDetailNew.dart';
import 'NewsDetail.dart';
import 'BooksDetail.dart';
import '../ApiResponses/BookmarkResponse.dart';
import '../ApiResponses/VideoData.dart';
import '../ApiResponses/NewsData.dart';

class ItemData {

  String book_id;
  String user_id;
  String quantity;
  ItemData({this.book_id, this.user_id,this.quantity});

  ItemData.fromJson(Map<String, dynamic> json)
      : book_id = json['book_id'],
        user_id = json['user_id'],
        quantity = json['quantity']
  ;

  Map<String, dynamic> toJson() {
    return {
      'book_id': book_id,
      'user_id': user_id,
      'quantity': quantity,
    };
  }
}
VideoData videodata=new VideoData();
NewsData newsData=new NewsData();
class NotificationListPage extends StatefulWidget {
  @override
  NotificationListPageState createState() {
    return NotificationListPageState();
  }
}

class NotificationListPageState extends State<NotificationListPage> {

  List mainData = new List();
  List<String> qtyData = new List();
  bool isLoading = false;
  String _chosenValue="1";
  bool _isInAsyncCall = false;
  String user_Token;


  String USER_ID;
  @override
  void initState() {
    super.initState();

    qtyData.add('1');
    qtyData.add('2');
    qtyData.add('3');
    qtyData.add('more');

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}
      setState(() {
        _isInAsyncCall = true;
      });

      getBookmarkList(user_Token).then((value) => {


        setState(() {

          _isInAsyncCall = false;
          isLoading = false;
          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
    });

  }

  Future<BookmarkListResponse> getBookmarkList(String user_Token) async {

    var body ={'none':'none'};
    MainRepository repository=new MainRepository();
    return repository.fetchNotificationData(body,user_Token);

  }


  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    print("device_height"+height.toString());

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
            title: Text('Notifications', style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),


        ),

        body:ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            // demo of some additional parameters
            opacity: 0.01,
            progressIndicator: CircularProgressIndicator(),
            child:   Container(

              child: Stack(  children: [

                mainData.length>0?

                _buildList() :Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child:_isInAsyncCall?Container():Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'You have not set any bookmark yet' ,
                            style: GoogleFonts.poppins(
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: 1.2,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,

                            ),
                          ),

                          SizedBox(height: 20),

                        ])


                )

                ,
              ]) ,))

    );
  }





  Widget _buildList() {

    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      itemCount: mainData.length , // Add one more item for progress indicator
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        /* if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {*/
        return GestureDetector(
            onTap: () =>
            {

              if(mainData[index].contentType==1){




                Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return VideoDetailNewPage(content: mainData[index].video);
                        }
                    ))
              }

              else if(mainData[index].contentType==2){


                Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return NewsDetailPage(content: mainData[index].news);
                        }
                    ))
              }
              else if(mainData[index].contentType==3){


                  Navigator.of(context, rootNavigator: true)
                      .push( // ensures fullscreen
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return BooksDetailPage(content: mainData[index].book);
                          }
                      ))
                }


            },
            child:mainData[index].contentType==1?
            _buildBoxBook(context,index, mainData[index].id, mainData[index].video.title, "New Video added"):mainData[index].contentType==2?_buildBoxBook(context,index, mainData[index].id, mainData[index].news.title,"New News Added"):_buildBoxBook(context,index, mainData[index].id, mainData[index].book.title, "New Book added"));



      }
      // }
      ,

    );
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
  Widget _buildBoxBook(BuildContext context,int index,int id,String title,String category){


// print("my_qty--"+qty);
    //  title= title.length>22?title=title.substring(0,22)+"...":title;
    return    SizedBox(child:Container(
        margin:EdgeInsets.fromLTRB(10.0,12.0,10.0,0.0) ,
        //  height: 170,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(

                  child:
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                          height: 80,
                          width:70,
                          alignment: Alignment.center,
                          // height: ScreenUtil().setHeight(175),

                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/thumbnail.png"),

                              alignment: Alignment.center,
                            ),

                          ),

                        ),
                        new Expanded(
                            flex: 7, child: Container(

                            child:Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(15,12,0,0),
                                      child:
                                      Text(title,   overflow: TextOverflow.ellipsis,
                                        maxLines: 3, style: GoogleFonts.poppins(
                                            fontSize:14.0,
                                            color: Color(0xFF000000).withOpacity(1),
                                            fontWeight: FontWeight.w700

                                        ),)),

                                  Padding(
                                      padding: EdgeInsets.fromLTRB(15,7,0,0),
                                      child: Text(category,   overflow: TextOverflow.ellipsis,
                                        maxLines: 1, style: GoogleFonts.poppins(
                                          fontSize:12.0,
                                          color: Color(0xFF000000),

                                        ),)),




                                ])))

                        ,



                        SizedBox(
                          width: 15,
                        ),
                      ])),



              SizedBox(
                height: 20,
              ),
              Divider(

                height: 1,

                thickness: 1,
                color: Color(AppColors.textBaseColor),
              )

            ]
        )));
  }
}