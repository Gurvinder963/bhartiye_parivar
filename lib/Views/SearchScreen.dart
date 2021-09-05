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
import '../ApiResponses/SearchResponse.dart';
import '../ApiResponses/VideoData.dart';
import '../ApiResponses/NewsData.dart';
import '../ApiResponses/BookData.dart';

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
class SearchScreenPage extends StatefulWidget {
  @override
  SearchScreenPageState createState() {
    return SearchScreenPageState();
  }
}

class SearchScreenPageState extends State<SearchScreenPage> {
  Widget appBarTitle = new Text("", style: new TextStyle(color: Colors.black),);
  List mainData = new List();
  List<String> qtyData = new List();
  bool isLoading = false;
  String _chosenValue="1";
  bool _isInAsyncCall = false;
  String user_Token;
  Icon actionIcon = new Icon(Icons.search, color: Colors.black,);
  TextEditingController _searchQuery = new TextEditingController();
  String USER_ID;
  @override
  void initState() {
    super.initState();

    qtyData.add('1');
    qtyData.add('2');
    qtyData.add('3');
    qtyData.add('more');
    setSearchBar();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);
     /* if (!isLoading) {
        setState(() {
          isLoading = true;
        });}
      setState(() {
        _isInAsyncCall = true;
      });*/



      return (prefs.getString('token'));
    });

  }
  @override
  void dispose() {
    _searchQuery.dispose();

    super.dispose();
  }


  void setSearchBar(){
    this.actionIcon = new Icon(Icons.close, color: Colors.black,);
    this.appBarTitle = new TextField(

      autofocus: true,
      textInputAction: TextInputAction.search,
      onChanged: (value){


        if(value.length>3){
          mainData.clear();
          getSearchList(user_Token,value).then((value) => {
            addData(value.data)

          });

        }




      },

      controller: _searchQuery,

      style: new TextStyle(
        color: Colors.black,

      ),
      decoration: new InputDecoration(
        //  prefixIcon: new Icon(Icons.search, color: Colors.black),
          hintText: "Search...",
          hintStyle: new TextStyle(color: Colors.black)
      ),
    );
   // _handleSearchStart();

  }

  void addData(SearchData data){

    List combineData = new List();


      combineData.addAll(data.videos);
      combineData.addAll(data.news);
      combineData.addAll(data.books);



    setState(() {

    _isInAsyncCall = false;
    isLoading = false;
    mainData.addAll(combineData);

    });

  }

  Future<SearchResponse> getSearchList(String user_Token,String keyword) async {
    var body =json.encode({"keyword":keyword});
  //  var body ={'keyword':'India'};
    MainRepository repository=new MainRepository();
    return repository.fetchSearchData(body,user_Token);

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
          title: appBarTitle,


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
                            'Please find something' ,
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

              if(mainData[index].content_type==1){




                Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return VideoDetailNewPage(content: mainData[index]);
                        }
                    ))
              }
             else if(mainData[index].content_type==2){



                Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return NewsDetailPage(content: mainData[index]);
                        }
                    ))
              }
              else{




                Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return BooksDetailPage(content: mainData[index]);
                        }
                    ))
              }



            },
            child:
            mainData[index].content_type==1?
            _buildBoxBook(context,index, mainData[index].id, mainData[index].title, "Video-"+mainData[index].videoCategory):
            mainData[index].content_type==2?
            _buildBoxBook(context,index, mainData[index].id, mainData[index].title,"News"):
            _buildBoxBook(context,index, mainData[index].id, mainData[index].title,"Book")
        );



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