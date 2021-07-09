import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';


class PayToAccountPage extends StatefulWidget {
  @override
  PayToAccountPageState createState() {
    return PayToAccountPageState();
  }
}


class PayToAccountPageState extends State<PayToAccountPage> {


  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Padding(
            padding: EdgeInsets.fromLTRB(30,30,30,10),
      child:  Text("Name : Bhartiya Parivar",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
    ),

              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child:  Text("Account No. : 20123456789343",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child:  Text("Account Type : Current Account",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child:  Text("IFSC : YES001001",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30,10,30,30),
                child:  Text("Bank Name : YES Bank",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
              ),
])


    )

            ])

      ),

    );
  }


}