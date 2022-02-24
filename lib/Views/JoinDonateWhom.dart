import 'dart:convert';

import 'package:bhartiye_parivar/ApiResponses/CheckDonateResponse.dart';
import 'package:bhartiye_parivar/Views/DonateUs.dart';
import 'package:bhartiye_parivar/Views/JoinUs.dart';
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
import '../localization/language/languages.dart';
import '../Interfaces/OnAnyDrawerItemOpen.dart';

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
class JoinDonateWhomPage extends StatefulWidget {
  final String from;


  JoinDonateWhomPage({Key key,@required this.from}) : super(key: key);


  @override
  JoinDonateWhomPageState createState() {
    return JoinDonateWhomPageState(from);
  }
}

class JoinDonateWhomPageState extends State<JoinDonateWhomPage> {

  String from;

  JoinDonateWhomPageState(String content){
    from=content;
  }

  List mainData = new List();
  List<String> qtyData = new List();
  bool isLoading = false;
  String _chosenValue="1";
  bool _isInAsyncCall = false;
  String user_Token;

  var _controller = TextEditingController();
  String USER_ID;
  @override
  void initState() {
    super.initState();



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

      getList(user_Token).then((value) => {
        {



          setState(() {

            _isInAsyncCall = false;
            isLoading = false;
             mainData.addAll(value.data);

          })
        }
      });

      return (prefs.getString('token'));
    });

  }

  Future<CheckDonateResponse> getList(String user_Token) async {

    var body =json.encode({"app_code":Constants.AppCode,"channel_id":Constants.AppCode,"token": user_Token,"userid": USER_ID,"type":from});
    MainRepository repository=new MainRepository();
    return repository.fetchCheckJoinDonateJAVA(body);

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
          title: Text(from+" Whom", style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),


        ),

        body:ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            // demo of some additional parameters
            opacity: 0.01,
            progressIndicator: CircularProgressIndicator(),
            child:   Container(

              child: Column(  children: [
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 0, top: 0, right: 15),
                      hintText:
                    "Search...",
                    ),

                  ),
                ),
                SizedBox(height: 20,),
                _buildList()

                ,
              ]) ,))

    );
  }

 openPage(){
    if(from=='Join'){
      Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
          MaterialPageRoute(
              builder: (BuildContext context) {
                return JoinUsPage();
              }
          ));
    }
    else {
      Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
          MaterialPageRoute(
              builder: (BuildContext context) {
                return DonateUsPage();
              }
          ));
    }
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

              openPage()

            },
            child:_buildBoxBook(context,index, mainData[index].channelImage, mainData[index].channelName));



      }
      // }
      ,

    );
  }



  Widget _buildBoxBook(BuildContext context,int index,String channelImage,String channelName){



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
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                          alignment: Alignment.center,
                           height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(channelImage),
                            ),
                          ),

                        ),

                        SizedBox(
                          width: 15,
                        ),
                        Text(mainData[index].channelName,

                            style: GoogleFonts.roboto(
                              fontSize:14.0,

                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,

                            )),


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