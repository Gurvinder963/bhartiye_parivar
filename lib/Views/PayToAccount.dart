import 'dart:convert';

import 'package:bhartiye_parivar/ApiResponses/DonateHomePageResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';


class PayToAccountPage extends StatefulWidget {
 final DonateHome donateData;

  PayToAccountPage({Key key, @required this.donateData}) : super(key: key);

  @override
  PayToAccountPageState createState() {
    return PayToAccountPageState(donateData);
  }
}


class PayToAccountPageState extends State<PayToAccountPage> {

DonateHome donateData;

PayToAccountPageState(DonateHome donateData){
this.donateData=donateData;
}

  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('Account Transfer'),
      ),
      body:   Container(
        width: double.infinity ,
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.fromLTRB(10,30,10,10),
                  child:  Text("You can make NEFT/RTGS/IMPS or \nBank deposit to the account below.\n This is VPA service by Razorpay",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                ),

        Card( elevation: 2,
            margin: EdgeInsets.fromLTRB(10,40,10,10),

            color: Color(0xFFe3e3e3),

        child:SizedBox(
          width: MediaQuery.of(context).size.width-100,
          
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Padding(
            padding: EdgeInsets.fromLTRB(30,30,30,10),
      child:  Text("Name : "+donateData.accountName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
    ),

              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child:  Text("Account No. : "+donateData.accountNumber,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child:  Text("Account Type : "+donateData.accountType,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child:  Text("IFSC : " +donateData.ifsc,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,30),
                child:  Text("Bank Name : "+donateData.bankName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),

 Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,30),
                child:  Text("UPI Id : "+donateData.upiId,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),

              



])


    )

          )])

      ),

    );
  }


}