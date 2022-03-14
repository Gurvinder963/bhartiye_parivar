import 'dart:convert';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/TxnResponse.dart';
import '../ApiResponses/DonateOrderSaveResponse.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Interfaces/OnCartCount.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'MyBooksTab.dart';
class DonatePaymentPage extends StatefulWidget {

  final String orderId;
  final String amount;
  final String id;
 final String trxnToken;
  

  DonatePaymentPage({Key key,@required this.orderId,@required this.amount,@required this.id,@required this.trxnToken}) : super(key: key);

  @override
  DonatePaymentPageState createState() {
    return DonatePaymentPageState(orderId,amount,id,trxnToken);
  }
}

class DonatePaymentPageState extends State<DonatePaymentPage> {
  String mid = "TWsple62048587367612", orderId = "", amount = "", txnToken = "";

  String user_Token;

  String uniqueOrderId;

 static const platform = const MethodChannel("razorpay_flutter");

   Razorpay _razorpay;


  DonatePaymentPageState(String orderId,String amount,String id,String trxnToken){
    this.orderId=orderId;
    this.amount=amount;
    this.uniqueOrderId=id;
    this.txnToken=trxnToken;

  }

  bool IsPayment=false;
  bool IsPaymentSuccess=false;

  String result = "";
  bool isStaging = true;
  String callbackUrl = "";
  bool restrictAppInvoke = false;
  bool _isInAsyncCall = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      String userId=prefs.getString(Prefs.USER_ID);
      user_Token=prefs.getString(Prefs.KEY_TOKEN);


      // setState(() {
      //   _isInAsyncCall = true;
      // });
      // callTXNTokenAPI(userId,amount,orderId,user_Token).then((value) => {

      //   setState(() {
      //     _isInAsyncCall = false;
      //   }),

      //   if(value.body!=null && value.body.txnToken!=null && !value.body.txnToken.isEmpty){
      //     setState(() {
      //       txnToken = value.body.txnToken;
      //     }),


      //     startPayment()
      //   }




      // });
    //  startPayment();
openCheckout();



      return (prefs.getString('token'));
    });

  }
 @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': amount,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    String res="";
    if(IsPaymentSuccess){
      res="You fulfilled you dharma. We hope you will continue to contribute for the mission as promised.\nJai Hind";
    }
    else{
      res="Payment Failed";
    }

    return WillPopScope(
        onWillPop: () {
          print('Backbutton pressed (device or appbar button), do whatever you want.');
          print("On bottom back clicked");

          //trigger leaving and use own data
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 3);


          //we need to return a future
          return Future.value(false);
        },
        child:Scaffold(
            resizeToAvoidBottomInset: false,
            /*  appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Payment", style: GoogleFonts.poppins(fontSize: 22,color: Color(0xFFFFFFFF))),
      ),*/
            body:   ModalProgressHUD(
                inAsyncCall: _isInAsyncCall,
                // demo of some additional parameters
                opacity: 0.01,
                progressIndicator: CircularProgressIndicator(),
                child:IsPayment?Container(

                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child:Column(

                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 250),
                          IsPaymentSuccess? new Image(
                            image: new AssetImage("assets/green_tick_pay.png"),
                            width: 120,
                            height:  120,
                            color: null,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ):new Image(
                            image: new AssetImage("assets/ic_fail.jpg"),
                            width: 120,
                            height:  120,
                            color: null,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                          SizedBox(height: 20),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40,7,40,3),
                              child:
                              Text(
                                res,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: ScreenUtil().setSp(16),

                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),),


                          SizedBox(height: 30),



                          Spacer(),
                          IsPayment?Align(
              alignment: FractionalOffset.bottomCenter,
              child:    GestureDetector(
                  onTap: () {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 3);
                  },child:Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Color(AppColors.BaseColor),
                padding: EdgeInsets.fromLTRB(0,8,0,8),
                child: Align(
                  alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                  child:  Text("DONE",
                    style: GoogleFonts.poppins( letterSpacing: 1.2,fontSize: ScreenUtil().setSp(16), color:  Color(0xFFffffff).withOpacity(0.8),fontWeight: FontWeight.w500),),
                ),
              )),
            ):Container(),

                        ])):Container()

            )

        ));
  }

  void clearCartData() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();


    Prefs.setCartCount(_prefs, "0");
  }

  void startPayment(){

    try {
      var response = AllInOneSdk.startTransaction(
          mid, orderId, amount, txnToken, null, isStaging, restrictAppInvoke);
      response.then((value) {
        print("payment_value"+value.toString());

        String payment_response="";
        /* if(value['error']){
         payment_response = value['errorMessage'];
       }else{*/
        if(value['STATUS']!=null){
          payment_response = value['STATUS'];
        }
        //  }

        bool isPaySuccess=false;
        if(payment_response=='TXN_SUCCESS'){

          //eventBus.fire(OnCartCount("FIND"));
          payment_response="success";
          isPaySuccess=true;
        }
        else{
          isPaySuccess=false;
        }
        print("txn_status"+payment_response);

        setState(() {
          IsPayment=true;
          IsPaymentSuccess=isPaySuccess;
          result = value.toString();
        });


        callOrderUpdateAPI(txnToken,payment_response,uniqueOrderId,user_Token).then((value) => {


          print("call_update_api"),
          setState(() {
            _isInAsyncCall = false;
          }),

        });



      }).catchError((onError) {
        print("oncatcherror");
        if (onError is PlatformException) {
          setState(() {
            IsPayment=true;
            IsPaymentSuccess=false;
            result = onError.message + " \n  " + onError.details.toString();
          });
        } else {
          setState(() {
            IsPayment=true;
            IsPaymentSuccess=false;
            result = onError.toString();
          });
        }


        /* callOrderUpdateAPI(txnToken,"cancelled",orderId,user_Token).then((value) => {
         print("call_update_api"),
         setState(() {
           _isInAsyncCall = false;
         }),
       });
*/

      });
    } catch (err) {
      print("oncatcherrorwer");
      // result = err.message;
      setState(() {
        IsPayment=true;
        IsPaymentSuccess=false;
        result = err.message;
      });
      /*   callOrderUpdateAPI(txnToken,"error",orderId,user_Token).then((value) => {
       print("call_update_api"),
       setState(() {
         _isInAsyncCall = false;
       }),
     });*/

    }


  }
  Future<AddToCartResponse> callPaymentAPI(String paymentId,String status,String orderId,String paymentResponse,String user_Token) async {

    var body ={'payment_id':paymentId,'payment_status':status,'order_id':orderId,'payment_response':paymentResponse};
    MainRepository repository=new MainRepository();
    return repository.fetchPaymentBookData(body,user_Token);

  }

  Future<TxnResponse> callTXNTokenAPI(String userId,String amount,String orderId,String user_Token) async {
    var body =json.encode({'user_id':userId,'cost':amount,'order_id':orderId});

    MainRepository repository=new MainRepository();
    return repository.fetchPostTxnToken(body,user_Token);

  }
  Future<DonateOrderSaveResponse> callOrderUpdateAPI(String payment_id,String payment_status,String orderId,String user_Token) async {
    var body =json.encode({'payment_id':payment_id,'payment_status':payment_status,'order_id':orderId});

    MainRepository repository=new MainRepository();
    return repository.fetchUpdateDonateOrder(orderId,body,user_Token);

  }
void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
  //   Fluttertoast.showToast(
  //       msg: "EXTERNAL_WALLET: " + response.walletName!,
  //       toastLength: Toast.LENGTH_SHORT);
  // }
  }
}