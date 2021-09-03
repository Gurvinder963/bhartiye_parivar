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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Interfaces/OnCartCount.dart';
import 'MyBooksTab.dart';
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
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    String res="";
    if(IsPaymentSuccess){
      res="Order placed successfully";
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
            SizedBox(height: 200),
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
            Text(
              res,
              style: GoogleFonts.roboto(
                fontSize: ScreenUtil().setSp(22),

                color: Colors.black,
                fontWeight: FontWeight.w500,

              ),
            ),
            SizedBox(height: 30),
            IsPaymentSuccess? Text(
              'Track your order / Read your book Here',
              style: GoogleFonts.roboto(
                fontSize: ScreenUtil().setSp(16),

                color: Colors.black,
                fontWeight: FontWeight.w500,

              ),
            ):Container(),
            SizedBox(height: 20),
            IsPaymentSuccess? _addBooksButton():Container(),
            Spacer(),
          /*  IsPayment?Align(
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
            ):Container(),*/

          ])):Container()

      )

    ));
  }
  Widget _addBooksButton() {
    return InkWell(
      onTap: () {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 3);
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return MyBooksTabPage();
                }
            ) );

      },

      child: Container(
        width: 150,
        height: ScreenUtil().setWidth(40),
        margin: EdgeInsets.fromLTRB(0,0,0,10),

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
          'My Books',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
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


       callOrderUpdateAPI(txnToken,payment_response,orderId,user_Token).then((value) => {

       clearCartData(),
       eventBus.fire(OnCartCount("FIND")),
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
  Future<AddToCartResponse> callOrderUpdateAPI(String payment_id,String payment_status,String orderId,String user_Token) async {
    var body =json.encode({'payment_id':payment_id,'payment_status':payment_status,'order_id':orderId});

    MainRepository repository=new MainRepository();
    return repository.fetchUpdateOrder(body,user_Token);

  }


}