import 'dart:convert';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Repository/MainRepository.dart';
import'../ApiResponses/ReferHistoryResponse.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ApiResponses/AddToCartResponse.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
class ReferHistoryPage extends StatefulWidget {
  @override
  ReferHistoryPageState createState() {
    return ReferHistoryPageState();
  }
}

class ReferHistoryPageState extends State<ReferHistoryPage> {
  bool _permissionReady;
  String user_Token;
  List mainData = new List();
  bool isLoading = false;
  bool _isInAsyncCall = false;
  String page = "1";

  String _localPath;
  final myControllerName = TextEditingController();
  final myControllerPageNo = TextEditingController();
  showAlertDialogValidationdELETE(BuildContext context,String message,String id,int index) {

    Widget yesButton = FlatButton(
      child: Text("YES"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          _isInAsyncCall = true;
        });
        postDeleteReferItem(id.toString(),user_Token)
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
           // showAlertDialogValidation(context,"Some error occured!");
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




  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);


      setState(() {
        _isInAsyncCall = true;
      });
      getReferList(user_Token,"").then((value) => {

        setState(() {

          _isInAsyncCall = false;
          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
    });

  }

  Future<ReferHistoryResponse> getReferList(String user_Token,String keyword) async {

    var body ={'app_code':Constants.AppCode,'page': page.toString(),
       'per_page': "10",'keyword':keyword};
    MainRepository repository=new MainRepository();
    return repository.fetchReferData(body,user_Token);

  }
  Future<AddToCartResponse> postDeleteReferItem(String id,String token) async {

    //  print('my_token'+token);
  //  var body =json.encode({"id":id});
    print(id);
    MainRepository repository=new MainRepository();
    return repository.fetchDeleteReferData(id,token);

  }
  _makingPhoneCall(String phone) async {
    var url = 'tel:'+phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Widget _buildList() {


    return

      ListView.builder(
        itemCount: mainData.length , // Add one more item for progress indicator

        itemBuilder: (BuildContext context, int index) {
          var dte= mainData[index].createdAt.toString().split(" ");
          return GestureDetector(
              onTap: () =>
              {


              },
              child:Container(
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),

                            child:
                            Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child:Text(mainData[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize:14.0,

                                            color: Color(0xFF000000),
                                            fontWeight: FontWeight.w500,

                                          ))),
                                  Expanded(
                                      flex: 1,
                                      child:GestureDetector(
                                          onTap: () =>
                                          {
                                            _makingPhoneCall(mainData[index].mobile)

                                          },child:Text(mainData[index].mobile,
                                        textAlign: TextAlign.center,

                                        style: GoogleFonts.roboto(
                                          fontSize:13.0,

                                          color: Color(0xFF0000ff),
                                          fontWeight: FontWeight.w500,

                                        ),))),
                                  Expanded(
                                      flex: 1,
                                      child:Text(mainData[index].pincode,

                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize:14.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ),)),
                                  Expanded(
                                      flex: 1,
                                      child:Text(dte[0],
                                        textAlign: TextAlign.center,

                                        style: GoogleFonts.roboto(
                                          fontSize:14.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ),)),
                                  Expanded(
                                      flex: 1,
                                      child:

                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(width: 10,),
                                      Image(
                                        image: mainData[index].refer_status?new AssetImage("assets/green_tick_pay.png"):new AssetImage("assets/ic_failure.png"),
                                        width: 18,
                                        height:  18
                                        ,
                                        color: null,
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.center,
                                      ),
                                            SizedBox(width: 10,),
                                            mainData[index].refer_status?Container(width: 20,):GestureDetector(
                                        onTap: () =>
                                        {

                                          showAlertDialogValidationdELETE(context,"Are you sure you want to remove this item?",mainData[index].id.toString(),index)
                                        },
                                        child:Image(
                                              image:new AssetImage("assets/ic_remove.png"),
                                              width: 20,
                                              height:  20,
                                              color: null,
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.center,
                                            ))
                                    ])
                                    ,),
                                ]

                            ),),

                         Divider(
                          color: Colors.grey,
                        ),
                      ])


              )



          );

        },



      );
  }




  @override
  Widget build(BuildContext context) {
    DataTableSource _data = MyData(mainData,context,user_Token);
    double width=MediaQuery.of(context).size.width;
    double wid=(width/5)-65;
    print("---widht---");
    print(width);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Refer History"),
      ),
      body:  ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          // demo of some additional parameters
          opacity: 0.01,
          progressIndicator: CircularProgressIndicator(),
          child:SingleChildScrollView(
    child: Container(child:
            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [

Container(
    color: Colors.black54,
    padding: const EdgeInsets.fromLTRB(0.0,8.0,0.0,8.0),
    child:
                Row(

                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child:    Text("Name",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize:15.0,

                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.w500,

                              ))),
                      Expanded(
                          flex: 1,
                          child:Text("Mobile",
                            textAlign: TextAlign.center,

                            style: GoogleFonts.roboto(
                              fontSize:15.0,

                              color: Color(0xFFffffff),
                              fontWeight: FontWeight.w500,

                            ),)),
                      Expanded(
                          flex: 1,
                          child:Text("Pin",

                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize:15.0,

                              color: Color(0xFFffffff),
                              fontWeight: FontWeight.w500,

                            ),)),
                      Expanded(
                          flex: 1,
                          child:Text("Ref. Date",
                            textAlign: TextAlign.center,

                            style: GoogleFonts.roboto(
                              fontSize:15.0,

                              color: Color(0xFFffffff),
                              fontWeight: FontWeight.w500,

                            ),)),
                      Expanded(
                          flex: 1,
                          child:Text("Status",
                            textAlign: TextAlign.center,

                            style: GoogleFonts.roboto(
                              fontSize:15.0,

                              color: Color(0xFFffffff),
                              fontWeight: FontWeight.w500,

                            ),))
                    ]

                )),
          Container(height: (MediaQuery.of(context).size.height) * 0.68, child:

                 _buildList()),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[


              Container(width: (MediaQuery.of(context).size.width) * 0.6, child:
                TextField(

                  textCapitalization: TextCapitalization.sentences,
                  controller: myControllerName,
                  obscureText: false,
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),

                  decoration: InputDecoration(
                    labelText:"Search by name,phone,pincode",

                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.grey,fontWeight: FontWeight.w700),
                    hintStyle: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.black,fontWeight: FontWeight.w700),

                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),

                    contentPadding: EdgeInsets.all(7),
                  ),
                )),


                  Container(
                      margin: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                      width: (MediaQuery.of(context).size.width) * 0.2, child:


                  TextField(

                    keyboardType: TextInputType.number,
                    controller: myControllerPageNo,
                    obscureText: false,
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),

                    decoration: InputDecoration(
                      labelText:"Page No.",

                      labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.grey,fontWeight: FontWeight.w700),
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.black,fontWeight: FontWeight.w700),

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),

                      contentPadding: EdgeInsets.all(7),
                    ),
                  ),

                    //_goButton()


                  ),

                  // Container(
                  //   margin: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                  //   width: (MediaQuery.of(context).size.width) * 0.1, child:
                  //
                  //   _goButton()
                  //
                  //
                  // )







                ]
              )
                ,
            Center(child: _searchButton())



              ],

            )


          )),

    ));
  }

  Widget _searchButton() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();

        if(myControllerName.text.isEmpty && myControllerPageNo.text.isEmpty){

        }

        else {
          if (myControllerName.text.isEmpty) {
            setState(() {
              mainData.clear();
              _isInAsyncCall = true;
              page = myControllerPageNo.text.toString();
            });
            getReferList(user_Token, "").then((value) =>
            {

              setState(() {
                _isInAsyncCall = false;
                mainData.addAll(value.data);
              })
            });
          }
          else {
            setState(() {
              mainData.clear();
              _isInAsyncCall = true;
              page="1";
            });

            getReferList(user_Token, myControllerName.text.toString()).then((
                value) =>
            {

              setState(() {
                _isInAsyncCall = false;
                mainData.addAll(value.data);
              })
            });
          }
        }
      },
      child: Container(
        width: 140,
        height: ScreenUtil().setWidth(36),
        margin: EdgeInsets.fromLTRB(0,20, 0, 10),
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
          'Search',
          style: GoogleFonts.poppins(
            fontSize: ScreenUtil().setSp(16),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _goButton() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          mainData.clear();
          _isInAsyncCall = true;
          page=myControllerPageNo.text.toString();
        });
        getReferList(user_Token,"").then((value) => {

          setState(() {

            _isInAsyncCall = false;
            mainData.addAll(value.data);

          })

        });
      },
      child: Container(
        width: 20,
        height: ScreenUtil().setWidth(42),
        margin: EdgeInsets.fromLTRB(1,0, 0, 0),
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
          'Go',
          style: GoogleFonts.poppins(
            fontSize: ScreenUtil().setSp(16),
            color: Colors.white,
          ),
        ),
      ),
    );
  }


}
class MyData extends DataTableSource {
  // Generate some made-up data
  List mainData;
  String user_token;
  BuildContext context;

  MyData(List mainData, BuildContext context,String user_token){
    this.mainData=mainData;
    this.user_token=user_token;
    this.context=context;

  }

  bool get isRowCountApproximate => false;
  int get rowCount => mainData.length;
  int get selectedRowCount => 0;
  Future<AddToCartResponse> postDeleteReferItem(String id,String token) async {

    //  print('my_token'+token);
    //  var body =json.encode({"id":id});
    print(id);
    MainRepository repository=new MainRepository();
    return repository.fetchDeleteReferData(id,token);

  }






  DataRow getRow(int index) {
    var dte= mainData[index].createdAt.toString().split(" ");
    return DataRow(cells: [
      DataCell(Text(mainData[index].name,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize:14.0,

            color: Color(0xFF000000),
            fontWeight: FontWeight.w500,

          ))),
      DataCell(Text(mainData[index].mobile,
        textAlign: TextAlign.center,

        style: GoogleFonts.roboto(
          fontSize:14.0,

          color: Color(0xFF0000ff),
          fontWeight: FontWeight.w500,

        ),)),
      DataCell(Text(mainData[index].pincode,

        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize:14.0,

          color: Color(0xFF000000),
          fontWeight: FontWeight.w500,

        ),)),
      DataCell(Text(dte[0],
        textAlign: TextAlign.center,

        style: GoogleFonts.roboto(
          fontSize:14.0,

          color: Color(0xFF000000),
          fontWeight: FontWeight.w500,

        ),)),
      DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10,),
            Image(
              image: mainData[index].refer_status?new AssetImage("assets/green_tick_pay.png"):new AssetImage("assets/ic_failure.png"),
              width: 18,
              height:  18
              ,
              color: null,
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
            ),
            SizedBox(width: 10,),
            mainData[index].refer_status?Container(width: 20,):GestureDetector(
                onTap: () =>
                {
                //  mainData.removeAt(index),
                //notifyListeners(),
                  showAlertDialogValidationdELETE(context,"Are you sure you want to remove this item?",mainData[index].id.toString(),index,user_token)
                },
                child:  Image(
                  image: new AssetImage("assets/ic_remove.png"),
                  width: 20,
                  height:  20,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ))
          ])),
    ]);
  }
  showAlertDialogValidationdELETE(BuildContext context,String message,String id,int index,String user_Token) {

    Widget yesButton = FlatButton(
      child: Text("YES"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        // setState(() {
        //   _isInAsyncCall = true;
        // });
        postDeleteReferItem(id.toString(),user_Token)
            .then((res) async {
          // setState(() {
          //   _isInAsyncCall = false;
          // });


          if (res.status == 1) {

            Fluttertoast.showToast(
                msg: "Item has been deleted !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
           // setState(() {
              mainData.removeAt(index);
              notifyListeners();
            //});



          }
          else {
            // showAlertDialogValidation(context,"Some error occured!");
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