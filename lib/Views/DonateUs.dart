import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PayToAccount.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DonateUsPage extends StatefulWidget {
  @override
  DonateUsPageState createState() {
    return DonateUsPageState();
  }
}


class DonateUsPageState extends State<DonateUsPage> {
  String _chosenValue= "Select";
  static const platform = const MethodChannel("razorpay_flutter");

   Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  }
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_54VVLcnAL17lQz',
      'amount': myControllerPhone.text,
      'name': 'Gurvinder Singh',
      'description': 'Donate',
      'prefill': {'contact': '9799125180', 'email': 'test@razorpay.com'},
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
  void dispose() {
    super.dispose();
    myControllerPhone.dispose();
    _razorpay.clear();
  }
  final myControllerPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text(AppStrings.DonatetoBhartiyaParivar),
      ),
      body:   Container(
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _entryField("Phone"),

          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 300,
              child:
          Text(
            "Method of Payment",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w500),
          )),

          Container(
              width: 300,
              margin: EdgeInsets.symmetric(vertical: 5),
              child:
                DropdownButton<String>(
                  isExpanded: true,
                  focusColor:Colors.white,
                  value: _chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'Select',
                    AppStrings.OnlinePayment,
                    AppStrings.Paytoaccount,


                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  hint:Text(
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

                   if(value=='Pay to account'){
                     Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                         MaterialPageRoute(
                             builder: (BuildContext context) {
                               return PayToAccountPage();
                             }
                         ) );
                   }

                  },
                )),

          _submitButton(),
          Divider(
            color: Colors.orange,
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,10),
            child:  Text("Why donate us", textAlign: TextAlign.center,
                style: TextStyle( fontSize: 14,color: Colors.black)),
          ),

        ])

      ),

    );
  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {
      /*  Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder:
                (context) =>
                VerifyOTPPage()
            ), ModalRoute.withName("/VerifyOTP")
        );*/
      //  openCheckout();

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
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
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

            controller: myControllerPhone,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:"Donation Amount",

              labelStyle: TextStyle(fontSize: 13,color: Colors.grey),
              hintStyle: TextStyle(fontSize: 13,color: Colors.black),

              border: UnderlineInputBorder(
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

}