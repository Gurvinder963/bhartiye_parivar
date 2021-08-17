import 'dart:convert';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Repository/MainRepository.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../Utils/AppStrings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Views/BookPayment.dart';
import '../ApiResponses/ShippingAddressResponse.dart';
class AddShippingAddressPage extends StatefulWidget {
  final String orderId;
  final String amount;

  AddShippingAddressPage({Key key,@required this.orderId,@required this.amount}) : super(key: key);


  @override
  AddShippingAddressPageState createState() {
    return AddShippingAddressPageState(orderId,amount);
  }
}

class AddShippingAddressPageState extends State<AddShippingAddressPage> {
  String  orderId = "", amount = "";
  String shpAddress='';
  bool _isInAsyncCall = false;
  List mainData = new List();
  final myControllerName = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerBuilding= TextEditingController();
  final myControllerLandmark= TextEditingController();
  final myControllerVillage= TextEditingController();
  final myControllerPincode= TextEditingController();
  final myControllerState= TextEditingController();
  final myControllerCity= TextEditingController();
  final myControllerTehsil= TextEditingController();

  String user_Token;
  AddShippingAddressPageState(String orderId,String amount){
    this.orderId=orderId;
    this.amount=amount;

  }

  @override
  void dispose() {


    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      getShippingList(user_Token).then((value) => {


        setState(() {

          _isInAsyncCall = false;

         mainData.addAll(value.data);

          if(value.data.isNotEmpty){

            myControllerName.text=value.data[0].fullName;
            myControllerPhone.text=value.data[0].phoneNumber;
            myControllerPincode.text=value.data[0].pincode;
            myControllerState.text=value.data[0].state;
            myControllerCity.text=value.data[0].city;
            myControllerTehsil.text=value.data[0].tehsil;
            myControllerBuilding.text=value.data[0].buildingName;
            myControllerVillage.text=value.data[0].village;
            myControllerLandmark.text=value.data[0].landmark;

          }

        })

      });
      return (prefs.getString('token'));
    });


  }

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
    child:Stack(  children: [ SingleChildScrollView(reverse: true, child:Container(

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
        minLines: 5,
        maxLines: 5,
        enabled: false,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: '',
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



    ]))),   Align(
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
                  Text('₹ '+amount,
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
    )])),

    );
  }
  showAlertDialogValidation(BuildContext context,String message) {

    // set up the button
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

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if(myControllerName.text.isEmpty){
          showAlertDialogValidation(context, "Please enter name!");
        }
        else if(myControllerPhone.text.isEmpty){
          showAlertDialogValidation(context, "Please enter phone no!");
        }
        else if(myControllerPincode.text.isEmpty){
          showAlertDialogValidation(context, "Please enter pincode!");
        }
        else if(myControllerState.text.isEmpty){
          showAlertDialogValidation(context, "Please enter state!");
        }
        else if(myControllerCity.text.isEmpty){
          showAlertDialogValidation(context, "Please enter city!");
        }
        else if(myControllerBuilding.text.isEmpty){
          showAlertDialogValidation(context, "Please enter H.No,Building Name etc.!");
        }
        else if(myControllerVillage.text.isEmpty){
          showAlertDialogValidation(context, "Please enter village, Colony, Sector etc.!");
        }
        else {
          setState(() {
            _isInAsyncCall = true;
          });



          addShippingAdressAPI(myControllerName.text,myControllerBuilding.text,myControllerVillage.text,myControllerLandmark.text,myControllerCity.text,myControllerTehsil.text,myControllerPincode.text,myControllerState.text,myControllerPhone.text,user_Token)
              .then((res) async {
            setState(() {
              _isInAsyncCall = false;
            });


            if (res.status == 1) {
              Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return BookPaymentPage(amount:amount,orderId:orderId.toString());
                      }
                  ) );

            }
            else {

            }
          });
        }

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
  Future<ShippingAddressResponse> getShippingList(String user_Token) async {

    var body ={'none':'none'};
    MainRepository repository=new MainRepository();
    return repository.fetchShippingAddressList(body,user_Token);

  }
  Future<AddToCartResponse> addShippingAdressAPI(String fullName,String buildingName,String village,String landmark,String city,String tehsil,String pincode,String state,String phoneNumber,String token) async {
    //  final String requestBody = json.encoder.convert(order_items);


    var body =json.encode({"full_name":fullName,"building_name":buildingName,"village":village,"landmark":landmark,"city":city,"tehsil":tehsil,"pincode":pincode,"state":state,"phone_number":phoneNumber});
    MainRepository repository=new MainRepository();

    if(mainData.isNotEmpty){
      return repository.fetchUpdateShippingAddress(mainData[0].id.toString(),body,token);
    }
    else{

    return repository.fetchAddShippingAddress(body,token);
    }

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
      mydata="H. No., Building name etc*";
      mkeyboardType=TextInputType.name;
    }
    else if(title=="landmark"){

      myController=myControllerLandmark;
      mydata="Near by famous place, Landmark (Optional) ";
      mkeyboardType=TextInputType.name;
    }
    else if(title=="village"){

      myController=myControllerVillage;
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