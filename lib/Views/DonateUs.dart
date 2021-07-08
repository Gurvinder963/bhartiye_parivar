import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PayToAccount.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';



class DonateUsPage extends StatefulWidget {
  @override
  DonateUsPageState createState() {
    return DonateUsPageState();
  }
}


class DonateUsPageState extends State<DonateUsPage> {
  String _chosenValue= AppStrings.OnlinePayment;

  @override
  void dispose() {

    // Clean up the controller when the widget is disposed.
    myControllerPhone.dispose();

    super.dispose();
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
          Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,10),
            child: new Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.orange,
                ),
                child: DropdownButton<String>(
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
          ),
          _submitButton(),
          Divider(
            color: Colors.orange,
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,10),
            child:  Text("Why donate us", textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
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
                colors: [Color(0xffFF8C00), Color(0xffFF8C00)])),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  Widget _entryField(String title, {bool isPassword = false}) {


    return Container(
      width: 200,
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
              hintText:"Donation Amount",

              labelStyle: TextStyle(fontSize: 13,color: Colors.black),
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