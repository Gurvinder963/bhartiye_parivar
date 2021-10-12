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
  String _localPath;





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
      getReferList(user_Token).then((value) => {

        setState(() {

          _isInAsyncCall = false;
          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
    });

  }

  Future<ReferHistoryResponse> getReferList(String user_Token) async {

    var body ={'lang_code':""};
    MainRepository repository=new MainRepository();
    return repository.fetchReferData(body,user_Token);

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
                                      child:    Text(mainData[index].name,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize:15.0,

                                            color: Color(0xFF000000),
                                            fontWeight: FontWeight.w500,

                                          ))),
                                  Expanded(
                                      flex: 1,
                                      child:Text(mainData[index].mobile,
                                        textAlign: TextAlign.center,

                                        style: GoogleFonts.roboto(
                                          fontSize:15.0,

                                          color: Color(0xFF0000ff),
                                          fontWeight: FontWeight.w500,

                                        ),)),
                                  Expanded(
                                      flex: 1,
                                      child:Text(mainData[index].pincode,

                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize:15.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ),)),
                                  Expanded(
                                      flex: 1,
                                      child:Text(dte[0],
                                        textAlign: TextAlign.center,

                                        style: GoogleFonts.roboto(
                                          fontSize:15.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ),)),

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

                    ]

                )),
          Expanded(child:
                _buildList()),

              ],

            )




          )),

    );
  }


}