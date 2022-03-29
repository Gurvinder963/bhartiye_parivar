import 'dart:convert';
import 'package:bhartiye_parivar/ApiResponses/DonateHomePageResponse.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:bhartiye_parivar/Views/InformationPage.dart';
import 'package:bhartiye_parivar/Views/WhyDonateUs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PayToAccount.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Repository/MainRepository.dart';
import '../ApiResponses/DonateOrderSaveResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Views/DonatePayment.dart';
import '../Views/DonationHistory.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DonateUsPage extends StatefulWidget {
  final String channel_id;
   final String channel_name;

  DonateUsPage({Key key, @required this.channel_id, @required this.channel_name}) : super(key: key);

  @override
  DonateUsPageState createState() {
    return DonateUsPageState(channel_id,channel_name);
  }
}

class DonateUsPageState extends State<DonateUsPage> {
  String channel_id;
  String mChannelName;

  DonateUsPageState(String channel_id,String channel_name) {
    this.channel_id = channel_id;
    this.mChannelName=channel_name;
  }

  List<String> ansList1 = <String>['Select'];

  String _chosenValue = "Select";
  bool _isInAsyncCall = false;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  bool _isPlayerReady = false;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;

  final List<String> _ids = [];
  String user_Token;

  String USER_ID;

 DonateHome donateHome;


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();

    var videoIdd = "A0pmI3FhoO4";

    _ids.add(videoIdd);

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {
      user_Token = prefs.getString(Prefs.KEY_TOKEN);

      USER_ID = prefs.getString(Prefs.USER_ID);

      getDonateHomeAPI().then((value) async {
        setState(() {

          if(value.data.isNotEmpty){

            donateHome=value.data[0];

 
             if(donateHome.onlinePayment=="yes" && donateHome.mid!=null && donateHome.mid.isNotEmpty){
               ansList1.add(AppStrings.OnlinePayment);
             }
              if(donateHome.accountDeposit=="yes"){
               ansList1.add("Account Deposit");
             }

if(donateHome.donateUsVideo.isNotEmpty){
 _controller = YoutubePlayerController(
      initialVideoId: donateHome.donateUsVideo,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
}


          }


        });
      });

      return (prefs.getString('token'));
    });

    _controller = YoutubePlayerController(
      initialVideoId:_ids.first ,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
   
  }

  void listener() {
    // if (_isPlayerReady && mounted) {
    //   setState(() {
    //     _playerState = _controller.value.playerState;
    //     _videoMetaData = _controller.metadata;
    //     print(_videoMetaData);
    //
    //   });
    // }
  }

  Future<DonateHomePageResponse> getDonateHomeAPI() async {
    var body = json.encode({
      "app_code": Constants.AppCode,
      "channel_id": channel_id,
      "token": user_Token,
      "userid": USER_ID,
      "page": "1"
    });
    MainRepository repository = new MainRepository();
    return repository.fetchDonateHomeJAVA(body);
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
  
   if(_controller!=null){
    _controller.pause();
  }
    super.deactivate();
  }

  @override
  dispose() {
    if (_controller!=null && _controller.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        Navigator.pop(context);
      });
    } else {
      myControllerAmount.clear();

      _controller.dispose();
      _idController.dispose();
      _seekToController.dispose();
      super.dispose();
    }

    super.dispose();
  }

  final myControllerAmount = TextEditingController();

  Widget mainWidget(Widget player) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(AppColors.BaseColor),
          toolbarHeight: 50,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]).then((_) {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    })
                  }),
          title: Text(AppStrings.Donate + " " + Constants.AppName),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                    Navigator.of(context, rootNavigator: true)
                                      .push(// ensures fullscreen
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                    return InformationPage(channelId:channel_id);
                                  }));
                },
                child: new Image(
                  image: new AssetImage("assets/ic_question.png"),
                  width: 30,
                  height: 30,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                )),
            SizedBox(
              width: 15,
            )
          ]),
      body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          // demo of some additional parameters
          opacity: 0.01,
          progressIndicator: CircularProgressIndicator(),
          child: SingleChildScrollView(
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                SizedBox(height: 20),
                _entryField("Phone"),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 300,
                    child: Text(
                      "Method of Payment",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500),
                    )),
                Container(
                    height: 35,
                    width: 300,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.orange),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: Theme(
                            data: new ThemeData(
                              primaryColor: Colors.orange,
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              focusColor: Colors.white,
                              value: _chosenValue,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                          items: ansList1.map((String user) {
                                    return DropdownMenuItem<String>(
                                      value: user,
                                      child: Container(
                                          padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0) ,
                                          child:Text(user,style:TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(14),
                                          fontWeight: FontWeight.w500),)),
                                    );
                                  }).toList(),
                              hint: Text(
                                "Please choose a payment type",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  _chosenValue = value;
                                });

                               
                              },
                            )))),
                SizedBox(height: 20),
                _submitButton(),
                SizedBox(height: 10),
                Divider(
                  color: Colors.orange,
                ),
                SizedBox(height: 10),
                _DonateHistoryButton(),
                SizedBox(height: 10),
                Divider(
                  color: Colors.orange,
                ),
donateHome!=null?(
                donateHome.donateUsVideo.isEmpty && donateHome.donateUsLink.isEmpty
                ?Container(height: 0,width: 0,):_whyDonateUsButton()
):Container(height: 0,width: 0,),
               donateHome!=null && donateHome.donateUsVideo!=null && donateHome.donateUsVideo.isNotEmpty?
                Container(
                    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    child: player):Container(width: 0,height: 0,),
              ])))),
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
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if (!isPortrait) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }

    return YoutubePlayerBuilder(
        onEnterFullScreen: () {
          Future.delayed(const Duration(milliseconds: 2000), () {
            _controller.play();
          });
        },
        onExitFullScreen: () {
          if (_controller.value.isFullScreen) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]).then((_) {
              Navigator.pop(context);
            });
          }
        },
        player: YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 9,
          showVideoProgressIndicator: false,
          progressIndicatorColor: Colors.blueAccent,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: _controller != null
                  ? Text(
                      _controller.metadata.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  : Container(),
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ],
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {},
        ),
        builder: (context, player) => mainWidget(player));
  }

  Future<DonateOrderSaveResponse> saveOrderAPI() async {
    //  final String requestBody = json.encoder.convert(order_items);

    var body = json.encode({"token":user_Token,"appcode":Constants.AppCode,"userid":USER_ID,"channel_id":channel_id,"amount": myControllerAmount.text.toString()});
    MainRepository repository = new MainRepository();

    return repository.fetchDonateOrderSaveJAVA(body);
  }

  showAlertDialogValidation(BuildContext context, String message) {
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

  Widget _DonateHistoryButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(// ensures fullscreen
            MaterialPageRoute(builder: (BuildContext context) {
          return DonationHistoryPage();
        }));
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
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
          'Donation History',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _whyDonateUsButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(// ensures fullscreen
            MaterialPageRoute(builder: (BuildContext context) {
          return WhyDonateUsPage(
              link: donateHome.donateUsLink, name: "Why Donate Us");
        }));
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
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
                colors: [Color(0xFF20d256), Color(0xFF20d256)])),
        child: Text(
          'Why Donate Us',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {

       if(_chosenValue=='Select'){

  showAlertDialogValidation(context, "Please select method of payment");
       }

       else if (_chosenValue == 'Account Deposit')
           {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(// ensures fullscreen
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                    return PayToAccountPage(donateData:donateHome);
                                  }));
                                }
       

       else if (myControllerAmount.text.trim().toString().isEmpty) {
          showAlertDialogValidation(context, "Please enter amount");
        } else {
          setState(() {
            _isInAsyncCall = true;
          });
          saveOrderAPI().then((res) async {
            String msg;
            setState(() {
              _isInAsyncCall = false;
            });
            Navigator.of(context, rootNavigator: true)
                .push(// ensures fullscreen
                    MaterialPageRoute(builder: (BuildContext context) {
              return DonatePaymentPage(
                  amount: myControllerAmount.text.trim().toString(),
                  orderId: res.data.orderId.toString(),
                  id: res.data.orderId.toString(),
                  trxnToken:res.data.trxntoken.toString(),
                  mID:donateHome.mid,
                  gateway:donateHome.gateway,
                  channel_name:mChannelName
                  
                  
                  );
            }));
          });
        }
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
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
          'Submit',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: myControllerAmount,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Donation Amount",
              labelStyle: TextStyle(fontSize: 13, color: Colors.grey),
              hintStyle: TextStyle(fontSize: 13, color: Colors.black),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 1.0),
              ),
              contentPadding: EdgeInsets.all(0),
            ),
          )
        ],
      ),
    );
  }
}
