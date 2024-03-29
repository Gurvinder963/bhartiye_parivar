import 'dart:io';
import 'dart:math';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';
import '../Interfaces/OnNumberChange.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import '../Repository/MainRepository.dart';
import '../Views/CreateProfile.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/LoginResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/VerifyMissCallResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Views/Home.dart';
//import 'package:device_info/device_info.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../ApiResponses/OTPResponse.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../Notification/push_nofitications.dart';




class VerifyOTPPage extends StatefulWidget {

  final String mobile;
  final String c_code;
  final String otpCode;
  final String from;
  final int requestCount;
  final DateTime otpSendDate;

  VerifyOTPPage({Key key,@required this.c_code,@required this.mobile,@required this.otpCode,@required this.otpSendDate,@required this.requestCount,@required this.from}) : super(key: key);




  @override
  VerifyOTPPageState createState() => VerifyOTPPageState(mobile,c_code,otpCode,otpSendDate,requestCount,from);
}

class VerifyOTPPageState extends State<VerifyOTPPage> with WidgetsBindingObserver{
  DateTime mOTPSendDate;
  int MyContentId;
  String mMobile;
  bool isVerifyMissCallBtnTapped=false;
  bool isCallAvailable=false;
  String mC_code;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Map<String, dynamic> _deviceData = <String, dynamic>{};

  bool isCallVerified=false;
  String mInvitedBy="";
  bool checkedValue=false;
  bool _isInAsyncCall = false;
  bool _isHidden = true;
  String mOTPCode;
  String from;
  int mRequestCount;
  VerifyOTPPageState(String mobile,String c_code,String otpCode,DateTime otpSendDate,int requestCount,String from){
    mMobile=mobile;
    mC_code=c_code;
    mOTPCode=otpCode;
    mOTPSendDate=otpSendDate;
    mRequestCount=requestCount;
    this.from=from;
  }

//  static final myTabbedPageKey = new GlobalKey<MyStatefulWidgetState>();

//  final myControllerPhone = TextEditingController();
  //final myControllerContryCode = TextEditingController();

  String fcm_token;

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



  _callNumber() async{
    var number = "+918929897587";
   //  var number = "+917941050748";
    //set the number here
     await FlutterPhoneDirectCaller.callNumber(number).then((value) => {
      print("suucessfully called"),
     setState(() {
     isCallAvailable = true;
     })

     });
   // res ? print("true") : print("false");

  }


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
    initPlatformState();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {
      print(prefs.getString('token'));
      fcm_token=prefs.getString('fcm_token');

      if(fcm_token==null){
        print("in null");
        PushNotificationsManager pfg =new PushNotificationsManager();
        pfg.init();
        Future.delayed(const Duration(milliseconds: 1000), () {

          Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
          Future<String> token;
          token = _prefs.then((SharedPreferences prefs) {
            print(prefs.getString('token'));
            fcm_token=prefs.getString('fcm_token');
            return (prefs.getString('fcm_token'));
          });
        });


      }





      return (prefs.getString('fcm_token'));
    });


    var s2 = mC_code;
    print(s2);
    String mobile;
    if(s2=='91') {
      var arr = mMobile.split(" ");
      String newStringMob = arr[0] + arr[1];

     // mobile = s2 + newStringMob;
      mobile = newStringMob;
    }
    else{
      mobile=mMobile;
    }
    print(mobile);
    var pin=nextIntOfDigits(4);

    print(pin);
    var date1 = DateTime.now();
    mOTPCode = pin.toString();
    mOTPSendDate=date1;
    // if(s2=='91') {
    //   String msg = pin.toString() +
    //       " is your one-time password (OTP) for login into App. Valid for 5 minutes. Ignore if sent by Mistake.";


      getOTPDataJAVA(mobile).then((value) =>
      {
      });


  //  }


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
    print(baseOs);
    print(manufacturer);
    print(model);


  }

  int nextIntOfDigits(int digitCount) {
    Random rnd = new Random();
    assert(1 <= digitCount && digitCount <= 9);
    int min = digitCount == 1 ? 0 : pow(10, digitCount - 1);
    int max = pow(10, digitCount);
    return min + rnd.nextInt(max - min);
  }
  Future<OTPResponse> getOTPData(String mobileNo,String msg) async {

    var body ={'user':'ravi10','password':'59034636','senderid':'NOTIFI','channel':'Trans','DCS':'0','flashsms':'0','number':mobileNo,'text':msg,'route':'15'};
    MainRepository repository=new MainRepository();
    return repository.fetchOTPData(body);

  }

  Future<AddToCartResponse> getOTPDataJAVA(String mobileNo) async {

    var body =json.encode({'number':mobileNo,'otp':mOTPCode,"appcode":Constants.AppCode,"password":"kranti2024","countrycode":mC_code});


   // var body ={'number':mobileNo,'otp':mOTPCode,"appcode":Constants.AppCode,"password":"kranti2024","countrycode":mC_code};
    MainRepository repository=new MainRepository();
    return repository.fetchOTPDataJAVA(body);

  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {


       print("onresume-----");
       isCallAvailable ? print("isCallAvailable") : print("isCallUNAvailable");
       isVerifyMissCallBtnTapped ? print("isVerifyMissCallBtnTapped") : print("isVerifyMissCallBtnTappednot");

      if(isVerifyMissCallBtnTapped){
        setState(() {
          _isInAsyncCall = true;

        });
        String newStringMob="";
        if(mC_code=='91') {
          var arr = mMobile.split(" ");
          newStringMob = arr[0] + arr[1];


        }
        else{
          newStringMob=mMobile;
        }

        String code="";
        if(mC_code=='91'){
          code=newStringMob;
        }
        else{
          code=newStringMob;
        }


        print("onresume--innner_call---");
        int countm = 0;

        Timer(Duration(seconds: 2),
                ()=>{


                  getVerifyMissCallAPINEW(code,mC_code).then((value) => {

                  setState(() {

                  _isInAsyncCall = false;

                  }),

                  if(value.data.verifyStatus==1){


                    loginAPICall("misscall")


                  }
                  else{

                  Fluttertoast.showToast(
                  msg: "Caller not verified !",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0)

                  }



                  })




                //   getVerifyMissCallAPI(code).then((value) => {
                //
                // setState(() {
                //
                // _isInAsyncCall = false;
                //
                // }),
                //
                // if(value.status==1){
                //   loginAPICall("misscall")
                // }
                // else{
                //
                // Fluttertoast.showToast(
                // msg: "Caller not verified !",
                // toastLength: Toast.LENGTH_SHORT,
                // gravity: ToastGravity.BOTTOM,
                // timeInSecForIosWeb: 1,
                // backgroundColor: Colors.black,
                // textColor: Colors.white,
                // fontSize: 16.0)
                //
                // }
                //
                //
                //
                // })


        }
        );
      }


    }
  }

  Future<AddToCartResponse> getNationalProfile(String id,String user_Token) async {


   // var body ={'unique_id':id,"appcode":Constants.AppCode,"password":user_Token};

    var body =json.encode({'userid':id,"appcode":Constants.AppCode,"token":user_Token});


    MainRepository repository=new MainRepository();
    return repository.fetchCreateProfileNational(body);

  }
  void loginAPICall(String verified_by){
    setState(() {
      _isInAsyncCall = true;
    });
    print("mcode"+mC_code);
    String varMobile="";
    if(mC_code=='91') {
      var arr = mMobile.split(" ");
      String newStringMob = arr[0] + arr[1];

      varMobile = newStringMob;
    }
    else{
      varMobile=mMobile;
    }



    getLoginResponse(mC_code,varMobile,verified_by)
        .then((res) async {
      setState(() {
        _isInAsyncCall = false;
      });


      if(from=='Edit'){
        eventBusNC.fire(OnNumberChange(varMobile,mC_code));

        Navigator.of(context, rootNavigator: true).pop(context);
      }
      else {
        if (res.status == 1) {
          getNationalProfile((res.data.user.id).toString(),(res.data.token).toString());
          SharedPreferences _prefs = await SharedPreferences.getInstance();


          Prefs.setUserLoginId(_prefs, (res.data.user.id).toString());
          Prefs.setUserLoginToken(_prefs, (res.data.token).toString());
          Prefs.setUserLoginName(_prefs, (res.data.user.fullName).toString());
          Prefs.setUserAge(_prefs, (res.data.user.age).toString());
          Prefs.setUserProfession(
              _prefs, (res.data.user.profession).toString());
          Prefs.setUserPostal(_prefs, (res.data.user.address).toString());

          Prefs.setUserMobile(_prefs, (res.data.user.mobileNo).toString());
          Prefs.setUserCCode(_prefs, (res.data.user.country_code).toString());


          Timer(Duration(seconds: 1),
                  () =>
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder:
                          (context) =>
                          HomePage()
                      ), ModalRoute.withName("/Home")
                  )
          );
        }
        else {
          Timer(Duration(seconds: 1),
                  () =>
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder:
                          (context) =>
                          CreateProfilePage(c_code: mC_code, mobile: mMobile)
                      ), ModalRoute.withName("/Profile")
                  )
          );
        }
      }

    });




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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Clean up the controller when the widget is disposed.
  //  myControllerPhone.dispose();
 //   myControllerContryCode.dispose();
    super.dispose();
  }






  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(AppColors.StatusBarColor).withOpacity(1),  //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.AppName,
        theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
    )
    ),

    home:SafeArea(
      child: Scaffold(

        body:   ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:SingleChildScrollView (
            child:
            Stack(
              alignment: Alignment.topCenter,
              children: [

                Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height/2)-20,


                    child: Container(


                      decoration: BoxDecoration(
                        color: Color(AppColors.BaseColor),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(40.0),
                            topLeft: Radius.circular(0.0),
                            bottomLeft: Radius.circular(40.0)),
                      ),

                    )


                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                        height: (MediaQuery.of(context).size.height)*0.15,
                        child:new Image(
                          image: new AssetImage("assets/splash.png"),
                          width: 140,
                          height:  140,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5.0),

                      child: Text(
                        'Verify',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(27),
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height)*0.67,
                        width: (MediaQuery.of(context).size.width)-10,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 6,

                        margin: EdgeInsets.fromLTRB(30,10,30,10),
                        color: Color(0xFFffffff),

                        child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                          SizedBox(height: 20),



                          Padding(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            child:  Text("Verify +"+mC_code+" "+mMobile, textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18),color: Colors.black,letterSpacing: 1.7,)),
                          ),

                          GestureDetector(
                              onTap: () =>
                              {
                                Navigator.of(context, rootNavigator: true).pop(context)

                              },child:Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,10),
                            child:  Text("Not correct ?", textAlign: TextAlign.center,
                                style:  GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14),color: Colors.red)),
                          )),

                          Padding(
                            padding: EdgeInsets.fromLTRB(10,5,10,10),
                            child:  Text("Waiting for automatically detect an SMS sent", textAlign: TextAlign.center,
                                style:  GoogleFonts.roboto( fontSize: ScreenUtil().setSp(14),color: Colors.black)),
                          ),

                          SizedBox(height: 30),

                          Theme(
                            data: ThemeData(
                              inputDecorationTheme: InputDecorationTheme(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                            child: OTPTextField(
                              length: 4,
                              width: 300,
                              fieldWidth: 40,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14)
                              ),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {


                                var date1 = DateTime.now();
                                print(mOTPSendDate.toString()+"hii");
                                final difference = date1.difference(mOTPSendDate);

                                if(difference.inMinutes>5){
                                  showAlertDialogValidation(context,"OTP has been expired!");
                                }
                                else if(pin!=mOTPCode){
                                  showAlertDialogValidation(context,"OTP not valid!");
                                }

                                else {

                                setState(() {
                                   _isInAsyncCall = true;
                                  });
                                print("mcode"+mC_code);


      loginAPICall("otp");


                      /*     getLoginResponse(mC_code,varMobile)
                              .then((res) async {
                                  setState(() {
                                    _isInAsyncCall = false;
                                  });


                                  if (res.status == 1) {

                                    SharedPreferences _prefs =await SharedPreferences.getInstance();


                                     Prefs.setUserLoginId(_prefs,(res.data.user.id).toString());
                                     Prefs.setUserLoginToken(_prefs,(res.data.token).toString());
                                     Prefs.setUserLoginName(_prefs,(res.data.user.fullName).toString());


                                    Timer(Duration(seconds: 1),
                                            ()=>Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(builder:
                                                (context) =>
                                                    HomePage()
                                            ), ModalRoute.withName("/Home")
                                        )
                                    );




                                  }
                                  else{

                                    Timer(Duration(seconds: 1),
                                            ()=>Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(builder:
                                                (context) =>
                                                    CreateProfilePage(c_code:mC_code,mobile:mMobile)
                                            ), ModalRoute.withName("/Profile")
                                        )
                                    );



                                  }


                                });
*/




                              }


                                },
                            ),
                          ),




                          Padding(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            child:  Text("Enter 4 DIGIT CODE", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(13),color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10,40,10,10),
                            child:  Text("Didn't recieve the code ?", textAlign: TextAlign.center,
                                style: TextStyle( fontSize: ScreenUtil().setSp(13),color: Colors.black)),
                          ),
                          _submitButton()
                        ]))),
                  ],
                ),
              ],
            ))),
      ),
    ));
  }
  Future<LoginResponse> getLoginResponse(String contry_code,String mobile,String verified_by) async {

    print("verifeied_by--------");
    print(verified_by);

    var body =json.encode({"mobile_no":mobile,"country_code":contry_code,"fcm_token":fcm_token,"app_name":Constants.AppName,"app_version":"1.1","device_version":baseOs,"device_model":model,"device_type":"Android","device_name":manufacturer,"app_unique_code":Constants.AppCode,"verified_by":verified_by});
    MainRepository repository=new MainRepository();
    return repository.fetchLoginData(body);

  }

  Future<AddToCartResponse> getVerifyMissCallAPI(String mobileNo) async {

    var body ={'who':mobileNo,'password':'qwerty'};
    MainRepository repository=new MainRepository();
    return repository.fetchVerifyMissCall(body);

  }

  Future<VerifyMissCallResponse> getVerifyMissCallAPINEW(String mobileNo,String cCode) async {

    var body =json.encode({'mobile_no':mobileNo,'country_code':cCode,'app_unique_code':Constants.AppCode});

   // var body ={'mobile_no':mobileNo,'country_code':cCode,'app_unique_code':Constants.AppCode};
    MainRepository repository=new MainRepository();
    return repository.fetchLoginVerifyMissCall(body);

  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isVerifyMissCallBtnTapped = true;
        });

        _callNumber();

      },

      child: Container(
        width: 250,
        margin: EdgeInsets.fromLTRB(0,10,0,10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.orange)
        ),

        child: Text(
          'Give Miss Call to Verify',
          style: TextStyle(fontSize: 18, color:Color(AppColors.BaseColor),fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}




