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


class BookPaymentPage extends StatefulWidget {
  @override
  BookPaymentPageState createState() {
    return BookPaymentPageState();
  }
}

class BookPaymentPageState extends State<BookPaymentPage> {
  String mid = "", orderId = "", amount = "", txnToken = "";
  String result = "";
  bool isStaging = true;
  String callbackUrl = "";
  bool restrictAppInvoke = false;
  bool _isInAsyncCall = false;

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

}