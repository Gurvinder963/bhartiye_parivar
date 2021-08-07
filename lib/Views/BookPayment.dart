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

class BookPaymentPage extends StatefulWidget {

  final String orderId;
  final String amount;

  BookPaymentPage({Key key,@required this.orderId,@required this.amount}) : super(key: key);

  @override
  BookPaymentPageState createState() {
    return BookPaymentPageState(orderId,amount);
  }
}

class BookPaymentPageState extends State<BookPaymentPage> {
  String mid = "TWsple62048587367612", orderId = "", amount = "", txnToken = "";

  String user_Token;
  BookPaymentPageState(String orderId,String amount){
    this.orderId=orderId;
    this.amount=amount;

  }


  String result = "";
  bool isStaging = true;
  String callbackUrl = "";
  bool restrictAppInvoke = false;
  bool _isInAsyncCall = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      String userId=prefs.getString(Prefs.USER_ID);
      user_Token=prefs.getString(Prefs.KEY_TOKEN);


      setState(() {
        _isInAsyncCall = true;
      });
      callTXNTokenAPI(userId,amount,orderId,user_Token).then((value) => {

        setState(() {
          _isInAsyncCall = false;
        }),

        if(value.body!=null && value.body.txnToken!=null && !value.body.txnToken.isEmpty){
          setState(() {
            txnToken = value.body.txnToken;
          }),

          startPayment()
        }




      });





      return (prefs.getString('token'));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Payment", style: GoogleFonts.poppins(fontSize: 22,color: Color(0xFFFFFFFF))),

      ),
      body:   ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
      child:Container()

      )

    );
  }

 void startPayment(){

   try {
     var response = AllInOneSdk.startTransaction(
         mid, orderId, amount, txnToken, null, isStaging, restrictAppInvoke);
     response.then((value) {
       print(value);
       setState(() {
         result = value.toString();
       });
     }).catchError((onError) {
       if (onError is PlatformException) {
         setState(() {
           result = onError.message + " \n  " + onError.details.toString();
         });
       } else {
         setState(() {
           result = onError.toString();
         });
       }
     });
   } catch (err) {
     result = err.message;
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



}