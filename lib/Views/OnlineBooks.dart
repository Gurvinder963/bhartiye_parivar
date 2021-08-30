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
class OnlineBooksPage extends StatefulWidget {
  @override
  OnlineBooksPageState createState() {
    return OnlineBooksPageState();
  }
}

class OnlineBooksPageState extends State<OnlineBooksPage> {

  List mainData = new List();
  Set mainDataSet = new Set();
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

      getBooksList(user_Token).then((value) => {


        castList(value.data)




      });


      return (prefs.getString('token'));
    });

  }

  void castList(List data)
  {

   data.sort((a, b) => a.books_id.compareTo(b.books_id));
  /* for (int i = 0; i < data.length; i++) {
     mainDataSet.add(data[i]);
   }*/
   List newdata=new List();

   for (int i = 0; i < data.length; i++) {
     bool isFound = false;
     // check if the event name exists in noRepeat
     for (int z = 0; z < newdata.length; z++) {
       if (newdata[z].books_id == (data[i].books_id)) {
         isFound = true;
         break;
       }
     }
     if (!isFound) newdata.add(data[i]);
   }

     /* List newdata=new List();
      int j = 0;
      for (int i=0; i<data.length-1; i++){
        if (data[i].books_id != data[i+1].books_id){
          newdata.add(data[i]);
        }
      }*/
    setState(() {

      _isInAsyncCall = false;
      isLoading = false;
      mainData.addAll(newdata);

    });


/*    mainData.addAll(value);
    final jsonList = mainData.map((item) =>
        jsonEncode(item)).toList();

    // using toSet - toList strategy
    final uniqueJsonList = jsonList.toSet().toList();

    // convert each item back to the original form using JSON decoding
    final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    print(result);
    mainData.clear();*/


  }
  Future<BookListResponse> getBooksList(String user_Token) async {

    var body ={'none':'none'};
    MainRepository repository=new MainRepository();
    return repository.fetchMyBooksData(body,user_Token);

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
                          new Image(
                            image: new AssetImage("assets/empty_mybook.png"),
                            width: 200,
                            height:  200,
                            color: null,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                          Text(
                            'You have not purchased any \nbook yet for online reading' ,
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

                Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ViewOnlineBookPage();
                        }
                    ))
            },
            child:
            _buildBoxBook(context,index, mainData[index].id, mainData[index].title,
                mainData[index].thumbImage, mainData[index].publisher, mainData[index].cost.toString(),mainData[index].quantity.toString(),mainData[index].actual_cost.toString(),mainData[index].pageCount.toString(),mainData[index].lang_name));



      }
      // }
      ,

    );
  }
  Future<AddToCartResponse> postDeleteMyBooks(String id,String token) async {

    //  print('my_token'+token);
    var body =json.encode({"id":id});
    MainRepository repository=new MainRepository();
    return repository.fetchDeleteMyBooksData(body,token);

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
  Widget _buildBoxBook(BuildContext context,int index,int id,String title,String thumbnail,String publisher,String cost,String qty,String actualCost,String pageCount,String lang){

    lang=lang==null?"":lang;
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
                          margin: EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                          height: 140,
                          width: 100,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(thumbnail),
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
                                      child: Text(publisher,   overflow: TextOverflow.ellipsis,
                                        maxLines: 1, style: GoogleFonts.poppins(
                                          fontSize:12.0,
                                          color: Color(0xFF000000),

                                        ),)),

                                  Padding(
                                      padding: EdgeInsets.fromLTRB(15,7,0,0),
                                      child: Text(pageCount+" Pages",   overflow: TextOverflow.ellipsis,
                                        maxLines: 1, style: GoogleFonts.poppins(
                                          fontSize:12.0,
                                          color: Color(0xFF000000),

                                        ),)),


                                ])))

                        ,



                        new Expanded(
                            flex: 1,

                            child:PopupMenuButton(
                                icon: Icon(Icons.more_vert,size: 27,),
                                onSelected: (newValue) { // add this property

                                  if(newValue==2){

                                    showAlertDialogValidationdELETE(context,"Are you sure you want to remove this item ?",id.toString(),index);



                                  }


                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("Recommend Book"),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Remove"),
                                    value: 2,
                                  ),

                                ]
                            )
                        ),
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

  showAlertDialogValidationdELETE(BuildContext context,String message,String id,int index) {

    Widget yesButton = FlatButton(
      child: Text("YES"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          _isInAsyncCall = true;
        });
        postDeleteMyBooks(id.toString(),user_Token)
            .then((res) async {
          setState(() {
            _isInAsyncCall = false;
          });


          if (res.status == 1) {

            Fluttertoast.showToast(
                msg: "Item has been deleted !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {
              mainData.removeAt(index);

            });



          }
          else {
            showAlertDialogValidation(context,"Some error occured!");
          }
        });

      },
    );
    Widget noButton = FlatButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Constants.AppName),
      content: Text(message),
      actions: [
        yesButton,
        noButton,
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
}