import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Views/DashedLinePainter.dart';
import '../Views/LineDashedPainter.dart';
import '../Utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../Views/AddShippingAddress.dart';
import '../ApiResponses/TrackOrderResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
class TrackOrderPage extends StatefulWidget with WidgetsBindingObserver{
 // final TargetPlatform platform=null;
  @override
  TrackOrderPageState createState() {

    return TrackOrderPageState();
  }
}

class TrackOrderPageState extends State<TrackOrderPage>  {
  String _localPath;
  List mainData = new List();
  int id;
  String orderId;
  String orderDate;
  String consignmentNo;
  String orderStatus;
  bool _isInAsyncCall = false;
  bool _permissionReady;
  String user_Token;

  String USER_ID;
  Future<bool> _checkPermission() async {
   var platform = Platform;
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
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
      USER_ID=prefs.getString(Prefs.USER_ID);


      setState(() {
        _isInAsyncCall = true;
      });

      getTrackOrderList(user_Token).then((value) => {




        setState(() {

          _isInAsyncCall = false;

          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
    });
    _prepare();
  }


  Widget _buildList() {
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      itemCount: mainData.length , // Add one more item for progress indicator

      itemBuilder: (BuildContext context, int index) {
        /* if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {*/
        return GestureDetector(
            onTap: () =>
            {


            },
            child:_buildBoxBook(context,index, mainData[index].id, mainData[index].orderId,"", "", "", mainData[index].orderItems,mainData[index].updatedAt));



      }
      // }
      ,

    );
  }

  Widget buildListChild(List<OrderItems> orderItems) {

    return ListView.builder(

      padding: EdgeInsets.all(8.0),
      itemCount: orderItems.length , // Add one more item for progress indicator
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        /* if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {*/

        String type="";
        if(orderItems[index].bookTypeId==1){
          type=" (Printed)";
        }
        else if(orderItems[index].bookTypeId==2){
          type=" (Online)";
        }

        return GestureDetector(
            onTap: () =>
            {


            },
            child:Text((index+1).toString()+". "+orderItems[index].title+type,
                style: GoogleFonts.poppins(fontSize: 13,color: Colors.black,)));



      }
      // }
      ,

    );
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(

      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.01,
        progressIndicator: CircularProgressIndicator(),
    child:   Container(
      child: Stack(  children: [

        mainData.length>0? _buildList() :Container(
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
                    'You have not any order yet' ,
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
      ]) ,)

    )

    );
  }  Widget _trackOrderButton() {
    return InkWell(
      onTap: () {

      /*  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddShippingAddressPage();
                }
            ) );
*/
      },

      child: Container(
        width: 160,
        height: ScreenUtil().setWidth(45),
        margin: EdgeInsets.fromLTRB(0,0,0,10),

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
          'Track now',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.black,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
  Future<Null> _prepare() async {
    _permissionReady = await _checkPermission();

  if (_permissionReady) {
      await _prepareSaveDir();
    }
  }
  Future<void> _prepareSaveDir() async {
    _localPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    var platform = Platform;
    print("my_platform"+platform.toString());
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path;
  }

  Widget _buildBoxBook(BuildContext context,int index,int id,String orderId,String orderDate,String consignmentNo,String orderStatus,List<OrderItems> orderItems,String updateAt){



    return   Container (
        margin:EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0) ,
        child: Card (
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 8,
            child:Container(
        margin:EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0) ,

        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child:Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

        Row(
        mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Padding(
                  padding: EdgeInsets.fromLTRB(10,4,0,0),
                  child:
                  RichText(
                    text: TextSpan(


                      children:  <TextSpan>[
                        TextSpan(text: 'Order Id: '
                            '', style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(15), color: Colors.black,  fontWeight: FontWeight.w600)),

                        TextSpan(text: orderId, style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14), color: Colors.black)),

                      ],
                    ),
                  ),),

              Spacer(),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,2,10,0),
                  child: Text(updateAt,   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.poppins(
                      fontSize:11.0,
                      color: Color(0xFF5a5a5a),

                    ),)),
              ]),
        Padding(
            padding: EdgeInsets.fromLTRB(10,8,10,0),
             child: MySeparator(color: Colors.grey)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child:  Column(

                        children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(10,4,0,0),
                        child:
                        Text("Consignment number:",   overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.poppins(
                            fontSize:13.0,
                            color: Color(0xFF1f2833).withOpacity(1),
                              fontWeight: FontWeight.w600
                          ),)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10,4,0,0),
                              child:
                              Text("RD123456789IN",   overflow: TextOverflow.ellipsis,
                                maxLines: 1, style: GoogleFonts.poppins(
                                  fontSize:13.0,
                                  color: Color(0xFF1f2833).withOpacity(1),

                                ),)),

                        ])),

                    SizedBox(width: 6),
                    Dash(
                        direction: Axis.vertical,
                        length: 58,
                        dashLength: 7,
                        dashColor: Colors.grey),

                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(10,4,10,0),
                              child:
                              Text("Order status:",   overflow: TextOverflow.ellipsis,
                                maxLines: 1, style: GoogleFonts.poppins(
                                  fontSize:13.0,
                                  color: Color(0xFF1f2833).withOpacity(1),
                                    fontWeight: FontWeight.w600
                                ),)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10,4,0,0),
                              child:
                              Text("Posted",   overflow: TextOverflow.ellipsis,
                                maxLines: 1, style: GoogleFonts.poppins(
                                  fontSize:13.0,
                                  color: Color(0xFF1f2833).withOpacity(1),

                                ),)),

                        ])),
                  ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,8,10,0),
                  child: MySeparator(color: Colors.grey))

              ,Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                        padding: EdgeInsets.fromLTRB(15,4,0,0),
                        child:
                        Text("Book List",   overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.poppins(
                            fontSize:13.0,
                                fontWeight: FontWeight.w600,
                            color: Color(0xFF000000)

                          ),)),

                    Spacer(),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10,8,10,0),
                        child: GestureDetector(
                            onTap: () {
                              _requestDownload();

                            },child: Container(
                            decoration: BoxDecoration(
                              color: Color(AppColors.BaseColor),
                                border: Border.all(color: Colors.black)
                            ),
                            padding: EdgeInsets.fromLTRB(5,3,5,3),

                            child:Text("Download Invoice",overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.poppins(
                            fontSize:12.0,
                                  fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),

                          ),)))),
                  ]),

              buildListChild(orderItems),

              Padding(
                  padding: EdgeInsets.fromLTRB(10,20,10,0),
                  child:
                  Text("Track your Consignment number from this link below after the order status change to posted.",   textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                        fontSize:12.0,
                      fontWeight: FontWeight.w500,
                        color: Color(0xFF000000)

                    ),)),
              SizedBox(height: 20),
              _trackOrderButton(),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,8,10,0),
                  child:
                  Text("Did n't get you order yet?",   textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                      fontSize:12.0,

                      color: Color(0xFF000000)

                  ),)),
              Padding(
                  padding: EdgeInsets.fromLTRB(10,12,10,0),
                  child:
                  Text("Contact us",   textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                      fontSize:12.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xFF000080),
                      fontWeight: FontWeight.w600
                  ),)),
              SizedBox(height: 10),
            ]))));
  }
  void _requestDownload() async {
     final taskId = await FlutterDownloader.enqueue(
        url: "http://www.africau.edu/images/default/sample.pdf",
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }
  Future<TrackOrderResponse> getTrackOrderList(String user_Token) async {

    var body ={'none':'none'};
    MainRepository repository=new MainRepository();
    return repository.fetchTrackOrderData(body,user_Token);

  }
}