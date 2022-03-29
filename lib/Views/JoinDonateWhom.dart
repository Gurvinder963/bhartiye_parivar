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
import '../ApiResponses/CheckDonateResponse.dart';
import '../ApiResponses/VideoData.dart';
import '../ApiResponses/NewsData.dart';
import '../localization/language/languages.dart';
import '../Interfaces/OnAnyDrawerItemOpen.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';

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
  final String fromScreen;
  final String channel_id;


  JoinDonateWhomPage({Key key,@required this.fromScreen,@required this.from,@required this.channel_id}) : super(key: key);


  @override
  JoinDonateWhomPageState createState() {
    return JoinDonateWhomPageState(from,fromScreen,channel_id);
  }
}

class JoinDonateWhomPageState extends State<JoinDonateWhomPage> {

  String from;
  String channelId;
  String fromScreen;

  JoinDonateWhomPageState(String content,String fromScreen,String channel_id){
    from=content;
    this.channelId=channel_id;
    this.fromScreen=fromScreen;
  }

  List mainData = new List();
  List<String> qtyData = new List();
  bool isLoading = false;
  String _chosenValue="1";
  bool _isInAsyncCall = false;
  String user_Token;
   bool _isApiCalled = false;

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

      getList(user_Token,"").then((value) => {
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

  Future<CheckDonateResponse> getList(String user_Token,String keyword) async {
   print(keyword);
    var body =json.encode({"app_code":Constants.AppCode,"channel_id":channelId,"token": user_Token,"userid": USER_ID,"type":from,"search":keyword,"page_no":"1"});
    MainRepository repository=new MainRepository();
    return repository.fetchCheckJoinDonateJAVA(body);

  }

void addData(List<CheckData> videoData) {
    setState(() {
      _isInAsyncCall = false;
      isLoading = false;
      mainData.addAll(videoData);
    });
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
          title: Text(from+" Whom ?"),


        ),

        body:ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            // demo of some additional parameters
            opacity: 0.01,
            progressIndicator: CircularProgressIndicator(),
            child:   Container(
              color: Color(0xFFf1f1f1),
              child: Column(  children: [
                SizedBox(height: 20,),


                fromScreen=='Menu'?Text(Constants.AppName +" has not faculty for "+from+". \n" +from +" Others", textAlign: TextAlign.center):Container(width: 0,height: 0,),
               SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  child: TextField(
                    controller: _controller,
                      onChanged: (value) {
            if (value.length > 1 && !_isApiCalled) {
              mainData.clear();
              setState(() {
                _isApiCalled = true;
              });
              getList(user_Token, value).then((value) => {
                    addData(value.data),
                    setState(() {
                      _isApiCalled = false;
                    })
                  });
            }
          },
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

 openPage(String mchannelId,String mchannelName){
    if(from=='Join'){
      Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
          MaterialPageRoute(
              builder: (BuildContext context) {
                return JoinUsPage(channel_id:mchannelId);
              }
          ));
    }
    else {
      Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
          MaterialPageRoute(
              builder: (BuildContext context) {
                return DonateUsPage(channel_id:mchannelId,channel_name:mchannelName);
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

              openPage(mainData[index].channelId,mainData[index].channelName)

            },
            child:_buildBoxBook(context,index, mainData[index].channelImage, mainData[index].channelName));



      }
      // }
      ,

    );
  }



  Widget _buildBoxBook(BuildContext context,int index,String channelImage,String channelName){



    return    SizedBox(child:Container(
        color: Colors.white,
        margin:EdgeInsets.fromLTRB(0.0,12.0,0.0,0.0) ,
        //  height: 170,
        width: MediaQuery.of(context).size.width,
      
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding:EdgeInsets.fromLTRB(0.0,12.0,0.0,12.0) ,
                  child:
                  Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
                    

                      children: <Widget>[
                        SizedBox(
                          width: 15,
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
                              fontSize:16.0,

                              color: Color(0xFF000000),
                          

                            )),


                      ])),




            ]
        )));
  }
}