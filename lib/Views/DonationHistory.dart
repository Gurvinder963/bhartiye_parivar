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
import'../ApiResponses/DonateHistoryResponse.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DonationHistoryPage extends StatefulWidget {
  @override
  DonationHistoryPageState createState() {
    return DonationHistoryPageState();
  }
}

class DonationHistoryPageState extends State<DonationHistoryPage> {
  bool _permissionReady;
  String user_Token;
  List mainData = new List();
  bool isLoading = false;
  bool _isInAsyncCall = false;
  String _localPath;

  Future<void> _prepareSaveDir() async {

    if(Platform.isAndroid){
      _localPath= await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    }
    else {
      _localPath =
          (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    }
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {

    final directory =
    await getApplicationDocumentsDirectory();
    return directory?.path;
  }
  Future<bool> _checkPermission() async {
    // var platform = Platform;
    if (Platform.isAndroid) {
      print("in android");
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
  void _requestDownload(String orderid,String id) async {

    _permissionReady = await _checkPermission();


    if (_permissionReady) {
      print("muuu");
      await _prepareSaveDir();
    }

    final taskId = await FlutterDownloader.enqueue(
        url: "http://bankjaal.in/public/api/v1/user-donation-invoice?order_id="+id,
        headers: {"auth": "test_for_sql_encoding"},
        fileName: "Invoice_"+orderid+".pdf",
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);

    Future.delayed(const Duration(milliseconds: 2000), () {

      Fluttertoast.showToast(
          msg: "Invoice will download at "+_localPath,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);


    });


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
      getDonationList(user_Token).then((value) => {

          setState(() {

            _isInAsyncCall = false;
            mainData.addAll(value.data);

          })

        });


      return (prefs.getString('token'));
    });

  }

  Future<DonateHistoryResponse> getDonationList(String user_Token) async {

    var body ={'lang_code':""};
    MainRepository repository=new MainRepository();
    return repository.fetchDonationHistoryData(body,user_Token);

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
                      Text("Date: "+dte[0],   overflow: TextOverflow.ellipsis,
                        maxLines: 1, style: GoogleFonts.roboto(
                        fontSize:15.0,
                        color: Color(0xFF5a5a5a),

                      ),)
                        ,
                        Spacer(),
                        Text("Amount: ₹"+mainData[index].amount+"/-",   overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.roboto(
                            fontSize:15.0,
                            color: Color(0xFF5a5a5a),

                          ),),
                      ])),
                  Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,10),

                      child:
              Row(


                  children: <Widget>[
                    Text("To: Bhartiya Parivar",   overflow: TextOverflow.ellipsis,
                      maxLines: 1, style: GoogleFonts.roboto(
                        fontSize:15.0,
                        color: Color(0xFF5a5a5a),

                      ),),
                    Spacer(),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                        child: GestureDetector(
                            onTap: () {

                              _requestDownload(mainData[index].orderId.toString(),mainData[index].id.toString());
                              // _prepare();
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
                  ]))
, Divider(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Donation History"),
      ),
      body:  ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child: Container(

        child:Expanded(
          child: _buildList(),

        )

    )),

    );
  }


}