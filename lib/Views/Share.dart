import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import 'ReferHistory.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import '../Utils/AppStrings.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
class SharePage extends StatefulWidget {
  @override
  SharePageState createState() {
    return SharePageState();
  }
}

class SharePageState extends State<SharePage> {

  String user_Token;
  bool _isInAsyncCall = false;
  @override
  void initState() {
    super.initState();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);






      return (prefs.getString('token'));
    });

  }
  Future<AddToCartResponse> saveReferAPI(name,mobile,pincode) async {
    //  final String requestBody = json.encoder.convert(order_items);


    var body =json.encode({"name":name,"mobile":mobile,"pincode":pincode});
    MainRepository repository=new MainRepository();

    return repository.fetchReferSave(body,user_Token);


  }

  Future _asyncInputDialog(BuildContext context) async {
    String teamName1 = '';
    String teamName2 = '';
    String teamName3 = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Constants.AppName),
          content: SizedBox(
              height: 200,
              child: Column(
            children: [
               TextField(

                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Please Enter Name', ),
                    onChanged: (value) {
                      teamName1 = value;
                    },
                  ),
            TextField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Please Enter phone', ),
                    onChanged: (value) {
                      teamName2 = value;
                    },
                  ),
              new TextField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Please Enter Pin', ),
                    onChanged: (value) {
                      teamName3 = value;
                    },
                  )
            ],
          )),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isInAsyncCall = true;
                });

                saveReferAPI(teamName1,teamName2,teamName3).then((res) async {
                  String msg;
                  setState(() {
                    _isInAsyncCall = false;
                  });
                  if(res.status==1){

                    Fluttertoast.showToast(
                        msg: "Data save successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);


                  }


                });

              },
            ),
          ],
        );
      },
    );
  }
  Future<ShortDynamicLink> getShortLink() async {
    setState(() {
      _isInAsyncCall = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://bhartiyeparivar.page.link',
        link: Uri.parse('https://bhartiyeparivar.page.link/content?invite=me'),
        //  link: Uri.parse('https://play.google.com/store/apps/details?id=com.nispl.studyshot&invitedby='+referral_code),
        androidParameters: AndroidParameters(
          packageName: 'com.bhartiyeparivar',
        ),
        iosParameters: IosParameters(
          bundleId: 'com.example',
          minimumVersion: '1.0.1',
          appStoreId: '1405860595',
        ));

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    return shortDynamicLink;
  }
  _onShare(BuildContext context,String title,String thumbnail) async {



      await Share.share(title,

      );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Share App"),
      ),
      body: ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:Container(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            SizedBox(height: 10,),
    GestureDetector(
    onTap: () {
      getShortLink().then((res) {
        setState(() {
          _isInAsyncCall = false;
        });
        var url = res.shortUrl.toString();

        _onShare(context,"Hey! Download "+AppStrings.AppName +" app from"
            ' ' +
            url,"");



      });
    },child:
    Container(
                padding: const EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
                child:
            Row(

                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  SizedBox(width: 20,),
                  Image(
                    image: new AssetImage("assets/share.png"),
                    width: 25,
                    height:  25,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                  SizedBox(width: 20,),
                  Image(
                    image: new AssetImage("assets/email.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                  SizedBox(width: 20,),
                  Image(
                    image: new AssetImage("assets/facebook.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                  SizedBox(width: 20,),
                  Image(
                    image: new AssetImage("assets/twitter.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                  SizedBox(width: 20,),
                  Image(
                    image: new AssetImage("assets/whatsapp.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                  SizedBox(width: 20,),
                  Image(
                    image: new AssetImage("assets/telegram.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                  SizedBox(width: 20,),
                ]))),
            SizedBox(height: 20,),
            Center(child:Text("Sharing report of ankit yadav",

              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.roboto(
                fontSize:15.0,

                color: Color(0xFF000000),
                fontWeight: FontWeight.w500,

              ),)),
SizedBox(height: 20,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("",)),
                  Expanded(
                      flex: 1,
                      child:Text("Referred",

                        textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,

                    ),)),
                  Expanded(
                      flex: 1,
                      child:Text("Installed",

                        textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,

                    ),)),
                  Expanded(
                      flex: 1,
                      child:Text("Pending",
                        textAlign: TextAlign.center,

                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,

                    ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Today",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                        fontSize:15.0,

                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,

                      ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Yesterday",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Last 7 Days",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Last 28 Days",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),
            SizedBox(height: 10,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:    Text("Total",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))),
                  Expanded(
                      flex: 1,
                      child:Text("10",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("20",

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text("30",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),

                ]

            ),
            SizedBox(height: 5,),
            Divider(

              height: 1,

              thickness: 1,
              color: Color(AppColors.textBaseColor),
            ),

            SizedBox(height: 20,),
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child:  GestureDetector(
                          onTap: () =>
                          {

                            Navigator.of(context, rootNavigator: true)
                                .push( // ensures fullscreen
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ReferHistoryPage();
                                    }
                                ))
                          },
                          child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.fromLTRB(6.0,8.0,6.0,8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                            color: Color(0xFFcccccc)

                          ),
                          child: Text("Refer History",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,

                          ))))),
                  Spacer(),
                  Expanded(
                      flex: 3,
                      child:GestureDetector(
                          onTap: () =>
                          {
                            _asyncInputDialog(context)

                          },
                          child:Container(

                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.fromLTRB(6.0,8.0,6.0,8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              color: Color(0xFFcccccc)
                          ),
                          child:Text("Add Refer Details",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)))),



                ]

            ),
          ]
      )

      )),

    );
  }


}