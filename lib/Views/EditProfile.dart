import 'dart:io';
import 'package:bhartiye_parivar/ApiResponses/GetProfileResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'VerifyOTP.dart';
import '../ApiResponses/OTPResponse.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';
import '../Interfaces/OnNumberChange.dart';
import 'package:flutter/services.dart';


import 'package:shared_preferences/shared_preferences.dart';
//import 'package:device_info/device_info.dart';
import '../Views/Home.dart';
import '../Utils/AppColors.dart';
import 'AppLanguage.dart';
import '../Utils/AppStrings.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/LoginResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/PinCodeResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../Views/Login.dart';




class EditProfilePage extends StatefulWidget {

  EditProfilePage({Key key,}) : super(key: key);




  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> with WidgetsBindingObserver{
  int MyContentId;
  String mContentType;
  String mInvitedBy="";
  String mMobile;
  String mC_code;
  String USER_ID;

  String oldPostal;
  String oldProfession;



  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String mAddress='';
  String _chosenValue="Select";
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  EditProfilePageState(){


  }

//  static final myTabbedPageKey = new GlobalKey<MyStatefulWidgetState>();

  final myControllerName = TextEditingController();
  final myControllerAge = TextEditingController();
  final myControllerPinCode= TextEditingController();
  var myControllerPhone = MaskedTextController(mask: "00000 00000");
  var myControllerContryCode = TextEditingController();

  String fcm_token;
  String user_Token;
  String USER_NAME="";

  String baseOs;

  String manufacturer;

  String model;
  String ipAddress;

  String SCREEN_NAME="Login_Screen";
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<PinCodeResponse> getPinAddressAPI(String pin) async {

    var body ={'pin_code':pin};
    MainRepository repository=new MainRepository();
    return repository.fetchPinAddress(body);

  }
  Widget _entryFieldPincode(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            onChanged: (text) {
              if(text.length>5){
                FocusScope.of(context).requestFocus(FocusNode());
                getPinAddressAPI(text).then((value) => {



                  if(value.status==1){
                    setState(() {
                      if(value.data.address!=null) {
                        mAddress = value.data.address.postOffice + ", " +
                            value.data.address.district + ", " +
                            value.data.address.region;
                      }
                      else{
                        mAddress="Address not found!";
                      }


                    }),
                  }
                  else{
                    showAlertDialogValidation(context,"pin not valid")
                  }



                });

              }
              else{
                setState(() {
                  mAddress="";
                });
              }


            },
            inputFormatters: [
              new LengthLimitingTextInputFormatter(6),
            ],
            keyboardType: TextInputType.number,
            controller: myControllerPinCode,
            obscureText: false,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),

            decoration: InputDecoration(
              labelText:"Your Postal PIN code",

              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.grey,fontWeight: FontWeight.w700),
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.black,fontWeight: FontWeight.w700),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }
  Widget _entryFieldAge(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(

            controller: myControllerAge,
            obscureText: false,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:"Age",

              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.grey,fontWeight: FontWeight.w700),
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.black,fontWeight: FontWeight.w700),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }

  Widget _entryFieldName(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[ ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]"))],
            textCapitalization: TextCapitalization.sentences,
            controller: myControllerName,
            obscureText: false,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),

            decoration: InputDecoration(
              labelText:"Full Name",

              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.grey,fontWeight: FontWeight.w700),
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(13),color: Colors.black,fontWeight: FontWeight.w700),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // myControllerContryCode.text="+91";
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {
      print(prefs.getString('token'));
      fcm_token=prefs.getString('fcm_token');
      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);
      getUserProfileAPI(user_Token).then((value) async {

     setData(value);
        USER_NAME=value.fullName;
      myControllerName.text = value.fullName;
        myControllerAge.text = value.age.toString();
        myControllerPinCode.text = value.address.toString();
      myControllerPhone.text = value.mobileNo.toString();
        mMobile=value.mobileNo.toString();
        mC_code=value.countryCode.toString();
      myControllerContryCode.text="+"+mC_code;
      _chosenValue = value.profession.toString();

      oldProfession=value.profession.toString();
      oldPostal=value.address.toString();
     setState(() {

     });
      });

      // USER_NAME=prefs.getString(Prefs.USER_NAME);
      // if(USER_NAME!=null && USER_NAME.isNotEmpty) {
      //   print(USER_NAME);
      //   myControllerName.text = USER_NAME;
      //   String USER_AGE = prefs.getString(Prefs.USER_AGE);
      //   myControllerAge.text = USER_AGE;
      //   String USER_PROFESSION = prefs.getString(Prefs.USER_PROFESSION);
      //   String USER_POSTAL = prefs.getString(Prefs.USER_POSTAL);
      //   mMobile = prefs.getString(Prefs.USER_MOBILE);
      //   mC_code = prefs.getString(Prefs.USER_C_CODE);
      //
      //   myControllerPinCode.text = USER_POSTAL;
      //   _chosenValue = USER_PROFESSION;
      //   print("fcm_token" + mMobile);
      //   myControllerPhone.text=mMobile;
      //   myControllerContryCode.text="+"+mC_code;
      //
      // }
      initPlatformState();
      eventBusNC.on<OnNumberChange>().listen((event) {
        // All events are of type UserLoggedInEvent (or subtypes of it).
        // print("my_cart_count"+event.count);
        Future.delayed(const Duration(milliseconds: 800), ()
        {

          myControllerPhone.text = event.mobile;
          myControllerContryCode.text = "+" + event.code;

          setState(() {
            mMobile = event.mobile;
            mC_code=event.code;
          });
          setState(() {
            _isInAsyncCall = true;
          });

          getProfileUpdateResponse(myControllerName.text, myControllerAge.text,
              oldProfession, oldPostal, event.mobile, event.code)
              .then((res) async {
            setState(() {
              _isInAsyncCall = false;
            });


            if (res.status == 1) {
             // getUpdateProfileJAVA();
              SharedPreferences _prefs = await SharedPreferences
                  .getInstance();


              Prefs.setUserLoginId(_prefs, (res.data.user.id).toString());
              //Prefs.setUserLoginToken(_prefs, (res.data.token).toString());
              Prefs.setUserLoginName(
                  _prefs, (res.data.user.fullName).toString());
              Prefs.setUserAge(_prefs, (res.data.user.age).toString());
              Prefs.setUserProfession(
                  _prefs, (res.data.user.profession).toString());
              Prefs.setUserPostal(_prefs, (res.data.user.address).toString());

              Prefs.setUserMobile(
                  _prefs, (res.data.user.mobileNo).toString());
              Prefs.setUserCCode(
                  _prefs, (res.data.user.country_code).toString());

              Fluttertoast.showToast(
                  msg: "Mobile no. Updated Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);

              profileUpdateJAVA().then((res) async {
              });

            }
            else {
              showAlertDialogValidation(context, "Oops! This mobile is using by another user!");
            }
          });


        });

      });

      return (prefs.getString('fcm_token'));
    });



  }
  Future<AddToCartResponse> profileUpdateJAVA() async {

    var body =json.encode({'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,});

    //var body ={'userid':USER_ID,"appcode":Constants.AppCode,"token":user_Token,"name":name,"phone":mobile,"pincode":pincode};
    MainRepository repository=new MainRepository();
    return repository.fetchChangeNumberJAVA(body);

  }
  void setData(GetProfileResponse value) async{

    SharedPreferences _prefs = await SharedPreferences.getInstance();


    Prefs.setUserLoginId(_prefs, (value.id).toString());

    Prefs.setUserLoginName(_prefs, (value.fullName).toString());
    Prefs.setUserAge(_prefs, (value.age).toString());
    Prefs.setUserProfession(
        _prefs, (value.profession).toString());
    Prefs.setUserPostal(_prefs, (value.address).toString());

    Prefs.setUserMobile(_prefs, (value.mobileNo).toString());
    Prefs.setUserCCode(_prefs, (value.countryCode).toString());



  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        print('Running on ${deviceData}');
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }



  _readAndroidBuildData(AndroidDeviceInfo build) {

    baseOs=build.version.release;
    manufacturer=build.manufacturer;
    model= build.model;


  }




  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.
    myControllerName.dispose();
    myControllerAge.dispose();
    myControllerPinCode.dispose();
    super.dispose();
  }



  showAlertDialogValidation(BuildContext context,String message) {

    // set up the button
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





  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1),//or set color with: Color(0xFF0000FF)
    ));
    return  Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: Color(AppColors.BaseColor),
              title: Text('Profile'),
            ),


            body:  ModalProgressHUD(
                inAsyncCall: _isInAsyncCall,
                // demo of some additional parameters
                opacity: 0.01,
                progressIndicator: CircularProgressIndicator(),
                child: SingleChildScrollView (
                    child:
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [

                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.height/2)-20,





                        ),


                        Column(

                          children: [
                            SizedBox(height: 20),


                            SizedBox(

                                child:Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 6,
                                    margin: EdgeInsets.fromLTRB(30,6,30,8),
                                    color: Color(0xFFffffff),

                                    child:Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                                      SizedBox(height: 18),



                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10,5,10,8),
                                        child:  Text(USER_NAME, textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),color: Colors.black)),
                                      ),

                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                           // _entryFieldName("Name"),
                                           // _entryFieldAge("Age"),

                                            Align(
                                              alignment: Alignment.topLeft,
                                              child:   Padding(
                                                  padding: EdgeInsets.fromLTRB(15,30,10,0),
                                                  child:Text("Your Phone Number", style: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.grey,fontWeight: FontWeight.w700))),

                                            ),


                                            _emailPasswordWidget(),

                                            Align(
                                              alignment: Alignment.center,
                                              child:   Padding(
                                                  padding: EdgeInsets.fromLTRB(15,12,10,0),
                                                  child: GestureDetector(
                                                      onTap: () {

                                                        Navigator.of(context, rootNavigator: true)
                                                            .push( // ensures fullscreen
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) {
                                                                  return LoginPage(from: "Edit"
                                                                  );
                                                                }
                                                            ));


                                                      },
                                                      child:Text("Change Phone Number", style: TextStyle(fontSize: ScreenUtil().setSp(16),color: Color(0xFF000080),fontWeight: FontWeight.w700)))),

                                            ),

                                            Align(
                                              alignment: Alignment.topLeft,
                                              child:   Padding(
                                                  padding: EdgeInsets.fromLTRB(15,30,10,0),
                                                  child:Text("Profession", style: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.grey,fontWeight: FontWeight.w700))),

                                            ),

                                            Padding(
                                              padding: EdgeInsets.fromLTRB(15,0,10,0),
                                              child:
                                              Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(width: 1.0, color: Colors.orange),
                                                  ),
                                                ),

                                                child:DropdownButtonHideUnderline(

                                                    child: Theme(
                                                      data: new ThemeData(
                                                        primaryColor: Colors.orange,
                                                      ),
                                                      child: DropdownButton<String>(
                                                        isExpanded: true,
                                                        focusColor:Colors.orange,
                                                        value: _chosenValue,
                                                        //elevation: 5,
                                                        style: TextStyle(color: Colors.white),
                                                        iconEnabledColor:Colors.orange,
                                                        items: <String>[
                                                          'Select',
                                                          'Activist / NGO / Politics',
                                                          'Business Person',
                                                          'Farmer',
                                                          'Labourer',
                                                          'Student / Preparing for Competitive Exams',
                                                          'News and Media',
                                                          'Judge / Retired Judge',
                                                          'Lawyer / Legal Services',
                                                          'Chartered Accountant/ Accountancy Services',
                                                          'Doctor / Medical and Health Services',
                                                          'Civil Services',
                                                          'Armed Forces',
                                                          'Police',
                                                          'Shop Owner/ Working at Shops',
                                                          'Digital Marketing',
                                                          'Advertisement Industry',
                                                          'Banking and Finance Sector',
                                                          'Self Employed',
                                                          'Teacher / Professor',
                                                          'Web Developer / Network Administrator',
                                                          'Sales Person',
                                                          'Post Office / Courier Services',
                                                          'Business Administration',
                                                          'Management Professional',
                                                          'Service Sector',
                                                          'Fashion Industry / Tailor',
                                                          'Beauty Artist',
                                                          'Construction Industry',
                                                          'Anganwadi Worker',
                                                          'Aviation Industry',
                                                          'Transportation Industry',
                                                          'Hotel Industry',
                                                          'Arts and Entertainment / Film Industry',
                                                          'Science and Technology',
                                                          'Engineer',
                                                          'Merchant Navy',
                                                          'E-Commerce',
                                                          'Real Estate',
                                                          'Tourism',
                                                          'Sports',
                                                          'PSU',
                                                          'Other Private Job',
                                                          'Other Government Job',
                                                          'Others',
                                                          'Unemployed',

                                                        ].map<DropdownMenuItem<String>>((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value,style:TextStyle(color:Colors.black),),
                                                          );
                                                        }).toList(),
                                                        hint:Text(
                                                          "Please choose a Profession",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: ScreenUtil().setSp(14),
                                                              fontWeight: FontWeight.w500),
                                                        ),
                                                        onChanged: (String value) {
                                                          FocusScope.of(context).requestFocus(FocusNode());
                                                          setState(() {
                                                            _chosenValue = value;
                                                          });
                                                        },
                                                      ), // Your Dropdown Code Here,
                                                    )),

                                              ),




                                            ),
                                            /* new Padding(
                              padding: EdgeInsets.fromLTRB(10,0,10,10),
                              child: new Divider(color: Colors.orange,)
                          ),*/

                                            mC_code=='91'?_entryFieldPincode("Pincode"):Container(),
                                            mC_code=='91'&& !mAddress.isEmpty?
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(15,0,0,0),
                                                child: Text(mAddress, style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(12), color: Colors.red,fontWeight: FontWeight.bold)
                                                )
                                            ):Container(),

                                          ]),  _submitButton(),
                                      SizedBox(height: 10,)
                                    ]))),
                          ],
                        ),
                      ],
                    ))),
  );

  }
  Widget _emailPasswordWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20),
        Flexible(
            flex: 2,child:
        _entryFieldCountryCode("Password", isPassword: true)),
        SizedBox(width: 5),
        Flexible(
            flex: 5,child:
        _entryField("Phone")),

      ],
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {


    return Container(

      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            enabled: false,
            controller: myControllerPhone,
            obscureText: false,
            style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 1.7,),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText:"Phone number",

              labelStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),
              hintStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(12),
            ),
          )
        ],
      ),
    );
  }

  Widget _entryFieldCountryCode(String title, {bool isPassword = false}) {


    return Container(
      width: 60,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            enabled: false,
            controller: myControllerContryCode,
            obscureText: false,
            style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(


              labelStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),
              hintStyle: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(14),color: Colors.black,fontWeight: FontWeight.w500),

              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              contentPadding: EdgeInsets.all(5),
            ),
          )
        ],
      ),
    );
  }

  Future<LoginResponse> getProfileResponse(String name,String age,String profession,String pincode,String mobile,String cCode) async {


    String varMobile="";
    if(cCode=='91') {
      var arr = mobile.split(" ");
      String newStringMob = arr[0] + arr[1];

      varMobile = newStringMob;
    }
    else{
      varMobile=mobile;
    }
    var body =json.encode({"full_name":name,"age":age,"address":pincode,"profession":profession,"country_code":cCode,"mobile_no":varMobile,"email":"","fcm_token":fcm_token,"app_name":Constants.AppName,"app_version":"1.1","device_version":baseOs,"device_model":model,"device_type":"Android","device_name":manufacturer});
    MainRepository repository=new MainRepository();
    return repository.fetchProfileData(body);

  }

  Future<LoginResponse> getProfileUpdateResponse(String name,String age,String profession,String pincode,String mobile,String cCode) async {


    String varMobile="";
    // if(cCode=='91' && USER_NAME==null) {
    //   var arr = mobile.split(" ");
    //   String newStringMob = arr[0] + arr[1];
    //
    //   varMobile = newStringMob;
    // }
    // else{
    varMobile=mobile;
    //}
    var body =json.encode({"full_name":name,"age":age,"address":pincode,"profession":profession,"country_code":cCode,"mobile_no":varMobile,"email":"","fcm_token":fcm_token,"app_name":Constants.AppName,"app_version":"1.1","device_version":baseOs,"device_model":model,"device_type":"Android","device_name":manufacturer});
    MainRepository repository=new MainRepository();
    return repository.fetchUpdateProfileData(body,user_Token);

  }

  Future<GetProfileResponse> getUserProfileAPI(String user_Token) async {

    var body ={'none':'none'};
    MainRepository repository=new MainRepository();
    return repository.fetchUserProfileData(body,user_Token);

  }

  Future<AddToCartResponse> getUpdateProfileJAVA() async {

    var body =json.encode({'id':USER_ID,"appcode":Constants.AppCode,"password":user_Token});


    //var body ={'id':USER_ID,"appcode":Constants.AppCode,"password":user_Token};
    MainRepository repository=new MainRepository();
    return repository.fetchUpdateProfileJava(body);

  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {






         if(_chosenValue=='Select'){
          showAlertDialogValidation(context, "Please select profession!");
        }
        else if(mC_code=='91' && myControllerPinCode.text.isEmpty){
          showAlertDialogValidation(context, "Please enter pincode!");
        }
        else if(myControllerPinCode.text.length<6){
          showAlertDialogValidation(context, "Pincode not valid!");
        }
        else if(mC_code=='91' && mAddress== 'Address not found!'){
           showAlertDialogValidation(context, "Please enter valid pincode!");
         }
        else {
          setState(() {
            _isInAsyncCall = true;
          });

          String postal="999999";
          if(mC_code=='91'){
            postal=myControllerPinCode.text;
          }

            print("update profile");
            getProfileUpdateResponse(myControllerName.text, myControllerAge.text,
                _chosenValue, postal, mMobile, mC_code)
                .then((res) async {
              setState(() {
                _isInAsyncCall = false;
              });


              if (res.status == 1) {
                getUpdateProfileJAVA();
                SharedPreferences _prefs = await SharedPreferences
                    .getInstance();


                Prefs.setUserLoginId(_prefs, (res.data.user.id).toString());
                //Prefs.setUserLoginToken(_prefs, (res.data.token).toString());
                Prefs.setUserLoginName(
                    _prefs, (res.data.user.fullName).toString());
                Prefs.setUserAge(_prefs, (res.data.user.age).toString());
                Prefs.setUserProfession(
                    _prefs, (res.data.user.profession).toString());
                Prefs.setUserPostal(_prefs, (res.data.user.address).toString());

                Prefs.setUserMobile(
                    _prefs, (res.data.user.mobileNo).toString());
                Prefs.setUserCCode(
                    _prefs, (res.data.user.country_code).toString());

                Fluttertoast.showToast(
                    msg: "Profile Update Successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);



                Navigator.of(context, rootNavigator: true).pop(context);

              }
              else {
showAlertDialogValidation(context, "Oops! This mobile is using by another user!");
              }
            });

          }





      },

      child: Container(
        width: 150,
        height: ScreenUtil().setWidth(40),
        margin: EdgeInsets.fromLTRB(0,30,0,10),
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
                colors: [ Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'UPDATE',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




