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
import '../ApiResponses/ReferDetailResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import '../Utils/AppStrings.dart';
import'../ApiResponses/ReferHistoryResponse.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
class SharePage extends StatefulWidget {
  @override
  SharePageState createState() {
    return SharePageState();
  }
}

class SharePageState extends State<SharePage> {
  List mainData = new List();
  String user_Token;
  String USER_NAME="";
  String USER_ID="";
  bool _isInAsyncCall = false;

  int todayReferred=0;
  int todayInstalled=0;
  int todayPending=0;

  int yesterdayReferred=0;
  int yesterdayInstalled=0;
  int yesterdayPending=0;


  int sevenDaysReferred=0;
  int sevenDaysInstalled=0;
  int sevenDaysPending=0;

  int twentyDaysReferred=0;
  int twentyDaysInstalled=0;
  int twentyDaysPending=0;

  int totalDaysReferred=0;
  int totalDaysInstalled=0;
  int totalDaysPending=0;



  @override
  void initState() {
    super.initState();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_NAME=prefs.getString(Prefs.USER_NAME);
      USER_ID=prefs.getString(Prefs.USER_ID);

      refreshPage();

      return (prefs.getString('token'));
    });

  }

  void refreshPage(){

    getReferDetail(user_Token).then((value) => {

      setState(() {

        _isInAsyncCall = false;
        todayReferred=value.data.todayReferred;
        todayInstalled=value.data.todayInstall;
       // if(todayReferred-todayInstalled>0){
          todayPending=todayReferred-todayInstalled;
        //}

        yesterdayInstalled=value.data.yesterdayInstall;
        yesterdayReferred=value.data.yesterdayReferred;
        //if(yesterdayReferred-yesterdayInstalled>0){
          yesterdayPending=yesterdayReferred-yesterdayInstalled;
        //}

        sevenDaysInstalled=value.data.weekInstall;
        sevenDaysReferred=value.data.weekReferred;
        //if(sevenDaysReferred-sevenDaysInstalled>0){
          sevenDaysPending=sevenDaysReferred-sevenDaysInstalled;
        //}


        twentyDaysInstalled=value.data.monthInstall;
        twentyDaysReferred=value.data.monthReferred;
        //if(twentyDaysReferred-twentyDaysInstalled>0){
          twentyDaysPending=twentyDaysReferred-twentyDaysInstalled;
        //}

        totalDaysInstalled=value.data.totalInstall;
        totalDaysReferred=value.data.totalReferred;
        //if(totalDaysReferred-totalDaysInstalled>0){
          totalDaysPending=totalDaysReferred-totalDaysInstalled;
        //}

      })

    });

    setState(() {
      _isInAsyncCall = true;
    });
    getReferList(user_Token).then((value) => {

      callMethod(value)
    });

  }

  callMethod(value){
    int lenght=3;
    if(value.data.length<3){
      lenght=value.data.length;
    }

    for (int i = 0; i < lenght; i++) {
      print("===in looooopp");
      mainData.add(value.data[i]);
    }
    setState(() {

      _isInAsyncCall = false;






    });
  }

  Future<ReferHistoryResponse> getReferList(String user_Token) async {

    var body ={'app_code':Constants.AppCode};
    MainRepository repository=new MainRepository();
    return repository.fetchReferData(body,user_Token);

  }
  Future<ReferDetailResponse> getReferDetail(String user_Token) async {

    var body ={'app_code':Constants.AppCode};
    MainRepository repository=new MainRepository();
    return repository.fetchReferDetailData(body,user_Token);


  }
  // Future<AddToCartResponse> saveReferAPI(name,mobile,pincode) async {
  //   //  final String requestBody = json.encoder.convert(order_items);
  //
  //
  //   var body =json.encode({"name":name,"mobile":mobile,"pincode":pincode,'app_code':Constants.AppCode});
  //   MainRepository repository=new MainRepository();
  //
  //   return repository.fetchReferSave(body,user_Token);
  //
  //
  // }

  Future<AddToCartResponse> saveReferAPIJAVA(name,mobile,pincode) async {

    var body =json.encode({'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,"name":name,"phone":mobile,"pincode":pincode});

    //var body ={'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,"name":name,"phone":mobile,"pincode":pincode};
    MainRepository repository=new MainRepository();
    return repository.fetchReferSaveJava(body);

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
              inputFormatters: [
                new LengthLimitingTextInputFormatter(10),
              ],
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Please Enter phone', ),
                    onChanged: (value) {
                      teamName2 = value;
                    },
                  ),
              new TextField(
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(6),
                ],
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
               // Navigator.of(context).pop();

                if(teamName1.isEmpty){
                  showAlertDialogValidation(context, "Please enter name!");
                }
                else if(teamName1.length<3){
                  showAlertDialogValidation(context, "Name length at least 3 character!");
                }

               else if(teamName2.isEmpty){
                  showAlertDialogValidation(context, "Please enter mobile!");
                }

                else if(teamName2.length<10){
                  showAlertDialogValidation(context, "Please enter valid mobile no.!");
                }

                else if(teamName3.isEmpty){
                showAlertDialogValidation(context, "Please enter pincode!");
                }
                else if(teamName3.length<6){
                showAlertDialogValidation(context, "Pincode not valid!");
                }
                else {
                  Navigator.of(context).pop();
                  setState(() {
                    _isInAsyncCall = true;
                  });
                  saveReferAPIJAVA(teamName1, teamName2, teamName3).then((
                      res) async {
                    String msg;
                    setState(() {
                      _isInAsyncCall = false;
                    });
                    if (res.status == 1) {
                      mainData.clear();
                      refreshPage();

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
                }
              },
            ),
          ],
        );
      },
    );
  }
  showAlertDialogValidation(BuildContext context,String message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
      //  Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.of(context).pop();
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

    double width=MediaQuery.of(context).size.width;
    double wid=(width/6)-5;

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


                  Container(
                      width: wid,
                      child:
                  Image(
                    image: new AssetImage("assets/share.png"),
                    width: 25,
                    height:  25,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  )),

        Container(
            width: wid,
            child: Image(
                    image: new AssetImage("assets/email.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  )),

        Container(
            width: wid,
            child: Image(
                    image: new AssetImage("assets/facebook.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  )),

        Container(
            width: wid,
            child: Image(
                    image: new AssetImage("assets/twitter.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  )),

        Container(
            width: wid,
            child:  Image(
                    image: new AssetImage("assets/whatsapp.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  )),

        Container(
            width: wid,
            child:  Image(
                    image: new AssetImage("assets/telegram.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  )),
                  SizedBox(width: 20,),
                ]))),
            SizedBox(height: 20,),
            Center(child:Text("Sharing report of "+USER_NAME,

              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.roboto(
                fontSize:20.0,

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
                      child:Text(todayReferred.toString(),
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text(todayInstalled.toString(),

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text((todayPending).toString(),
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
                      child:Text(yesterdayReferred.toString(),
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text(yesterdayInstalled.toString(),

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text((yesterdayPending).toString(),
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
                      child:Text(sevenDaysReferred.toString(),
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text(sevenDaysInstalled.toString(),

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text((sevenDaysPending).toString(),
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
                      child:Text(twentyDaysReferred.toString(),
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text(twentyDaysInstalled.toString(),

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text((twentyDaysPending).toString(),
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
                      child:Text(totalDaysReferred.toString(),
                        textAlign: TextAlign.center,

                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text(totalDaysInstalled.toString(),

                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize:15.0,

                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,

                        ),)),
                  Expanded(
                      flex: 1,
                      child:Text((totalDaysPending).toString(),
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
                                )).then((_) {
                                print("on back called");
                                mainData.clear();
                                refreshPage();

                            })
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
            SizedBox(height: 20,),
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
            Expanded(child:
            _buildList()),


          ]
      )

      )),

    );
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
                                          fontSize:14.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ))),
                                Expanded(
                                    flex: 1,
                                    child:Text(mainData[index].mobile,
                                      textAlign: TextAlign.center,

                                      style: GoogleFonts.roboto(
                                        fontSize:13.0,

                                        color: Color(0xFF0000ff),
                                        fontWeight: FontWeight.w500,

                                      ),)),
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
                                        mainData[index].refer_status?Container(): GestureDetector(
                                            onTap: () =>
                                            {

                                              showAlertDialogValidationdELETE(context,"Are you sure you want to remove this item?",mainData[index].id.toString(),index)
                                            },
                                            child:  Image(
                                              image: new AssetImage("assets/ic_remove.png"),
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

  Future<AddToCartResponse> postDeleteReferItem(String id,String token) async {

    //  print('my_token'+token);
    //  var body =json.encode({"id":id});
    print(id);
    MainRepository repository=new MainRepository();
    return repository.fetchDeleteReferData(id,token);

  }
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
              mainData.clear();


            });
            refreshPage();


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