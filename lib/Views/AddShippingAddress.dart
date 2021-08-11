import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AddShippingAddressPage extends StatefulWidget {
  @override
  AddShippingAddressPageState createState() {
    return AddShippingAddressPageState();
  }
}

class AddShippingAddressPageState extends State<AddShippingAddressPage> {
  bool _isInAsyncCall = false;
  final myControllerName = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerBuilding= TextEditingController();
  final myControllerLandmark= TextEditingController();
  final myControllerVillage= TextEditingController();
  final myControllerPincode= TextEditingController();
  final myControllerState= TextEditingController();
  final myControllerCity= TextEditingController();
  final myControllerTehsil= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
    title: Text('Address', style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),
        ),
      body:  ModalProgressHUD(
      inAsyncCall: _isInAsyncCall,
      // demo of some additional parameters
      opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:SingleChildScrollView(reverse: true, child:Container(
    padding:EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0)  ,
    child:Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[

      _entryField("full name"),
      _entryField("phone"),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child:  _entryField("pincode"), ),

            SizedBox(width: 6),


            Expanded(child: _entryField("state"), ),
          ]),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child:  _entryField("city"), ),

            SizedBox(width: 6),


            Expanded(child: _entryField("tehsil"), ),
          ]),
      _entryField("building"),
      _entryField("landmark"),
      _entryField("village"),
      SizedBox(height: 6),
      TextFormField(
        minLines: 2,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'description',
          hintStyle: TextStyle(
              color: Colors.black
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
      ),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom))


     ,

     Align(
        alignment: FractionalOffset.bottomCenter,
        child:    GestureDetector(
            onTap: () {


            },child:Container(

          decoration: BoxDecoration(
            color: Colors.white,

            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 6,
                blurRadius: 8,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          height: 60,
          width: MediaQuery.of(context).size.width,

          padding: EdgeInsets.fromLTRB(0,8,0,8),
          child:   Row(

              children: <Widget>[

                SizedBox(
                  width: 10,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10,0,0,0),
                    child:
                    Text('₹ 250',
                      style: GoogleFonts.roboto(
                          fontSize:25.0,
                          color: Color(0xFF1f1f1f).withOpacity(0.8),
                          fontWeight: FontWeight.w700

                      ),)) ,
                Spacer(),

                _submitButton(),
                SizedBox(
                  width: 10,
                ),

              ]),


        )),
      )

    ])))),

    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {


      },

      child: Container(
        width: 150,
        height: ScreenUtil().setWidth(40),

        //   padding: EdgeInsets.symmetric(vertical: 10),
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
          'Place Order',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }



  Widget _entryField(String title) {
    var myicon;
    var myController;
    var mydata;
    var mkeyboardType;
    if(title=="full name"){

      myController=myControllerName;
      mydata="Full Name (Required) *";
      mkeyboardType=TextInputType.name;

    }
    else if(title=="phone"){

      myController=myControllerPhone;
      mydata="Phone number (Required) *";
      mkeyboardType=TextInputType.number;
    }
    else if(title=="pincode"){

      myController=myControllerPincode;
      mydata="Pincode (Required) *";
      mkeyboardType=TextInputType.number;
    }
    else if(title=="state"){

      myController=myControllerState;
      mydata="State (Required) *";
      mkeyboardType=TextInputType.name;
    }
    else if(title=="city"){

      myController=myControllerCity;
      mydata="City (Required) *";
      mkeyboardType=TextInputType.name;
    }
    else if(title=="tehsil"){

      myController=myControllerTehsil;
      mydata="Tehsil/Taluka (Optional)";
      mkeyboardType=TextInputType.name;
    }
    else if(title=="building"){

      myController=myControllerBuilding;
      mydata="Father's Name, H. No., Building name etc*";
      mkeyboardType=TextInputType.name;
    }
    else if(title=="landmark"){

      myController=myControllerBuilding;
      mydata="Near by famous place, Landmark (Optional) ";
      mkeyboardType=TextInputType.name;
    }
    else if(title=="village"){

      myController=myControllerBuilding;
      mydata="Village, Colony, Sector etc. (Required) *";
      mkeyboardType=TextInputType.name;
    }
    return Container(

      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          TextField(
            keyboardType: mkeyboardType,
            controller: myController,
            obscureText: false,
            style: TextStyle(color: Colors.black),

            decoration: InputDecoration(
              labelText:mydata,

              labelStyle: TextStyle(fontSize: 13,color: Colors.black),
              hintStyle: TextStyle(fontSize: 13,color: Colors.black),

             // prefixIcon: Icon(myicon,color: Colors.black),

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
              ),

              contentPadding: EdgeInsets.all(12),
            ),
          )
        ],
      ),
    );
  }

}