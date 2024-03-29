import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyBooksTab.dart';
import 'BooksByLanguage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Repository/MainRepository.dart';
import 'BooksDetail.dart';
import'../ApiResponses/BookListResponse.dart';
import '../Views/BookGroupList.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/OrderResponse.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Views/BookPayment.dart';
import '../Interfaces/OnCartCount.dart';
import '../Views/AddShippingAddress.dart';
class ItemData {

  String book_id;
  String book_type_id;
  String user_id;
  String quantity;
  ItemData({this.book_id,this.book_type_id,this.user_id,this.quantity});

  ItemData.fromJson(Map<String, dynamic> json)
      : book_id = json['book_id'],
        book_type_id = json['book_type_id'],
        user_id = json['user_id'],
        quantity = json['quantity']
  ;

  Map<String, dynamic> toJson() {
    return {
      'book_id': book_id,
      'book_type_id': book_type_id,
      'user_id': user_id,
      'quantity': quantity,
    };
  }
}
class MyCartPage extends StatefulWidget {
  @override
  MyCartPageState createState() {
    return MyCartPageState();
  }
}

class MyCartPageState extends State<MyCartPage> {

  List mainData = new List();
  List<String> qtyData = new List();
  bool isLoading = false;
  String _chosenValue="1";
  bool _isInAsyncCall = false;
  String user_Token;
  int price;
  int deliveryCharges=20;
  int amountPayable;

  String USER_ID;
  @override
  void initState() {
    super.initState();

    qtyData.add('1');
    qtyData.add('2');
    qtyData.add('3');
    qtyData.add('4');
    qtyData.add('5');
    qtyData.add('more');

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

       user_Token=prefs.getString(Prefs.KEY_TOKEN);
       USER_ID=prefs.getString(Prefs.USER_ID);
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}
       setState(() {
         _isInAsyncCall = true;
       });
       int tPrice=0;
      getBooksList(user_Token).then((value) => {


         for(int i=0;i<value.data.length;i++){
           tPrice=tPrice+value.data[i].cost
         },

        setState(() {
          amountPayable=tPrice+deliveryCharges;
          price=tPrice;
          _isInAsyncCall = false;
          isLoading = false;
          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
    });

  }

  Future<BookListResponse> getBooksList(String user_Token) async {

    var body ={'none':'none'};
    MainRepository repository=new MainRepository();
    return repository.fetchCartListBooksData(body,user_Token);

  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    print("device_height"+height.toString());

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Color(AppColors.BaseColor),
          title: Text('Cart', style: GoogleFonts.roboto(fontSize: 24,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),

        ),
        body:ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:   Container(

           child: Stack(  children: [

             mainData.length>0?ListView(


                 padding: EdgeInsets.all(0.0),
              children: <Widget>[

                mainData.length>0?_buildList():Container(),



                mainData.length>0?Padding(
                    padding: EdgeInsets.fromLTRB(15,15,0,0),
                    child:
                    Text("PRICE DETAILS",
                      maxLines: 1, style: GoogleFonts.poppins(
                          fontSize:18.0,
                          color: Color(0xFF393939).withOpacity(0.8),


                      ),)):Container(),
                mainData.length>0?Padding(
                    padding: EdgeInsets.fromLTRB(15,15,15,0),
                    child:
                    Divider(

                      height: 1,

                      thickness: 1,
                      color: Color(0xFFc3c3c3),
                    ),):Container(),


                mainData.length>0? Container(
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),

                    margin: EdgeInsets.fromLTRB(0.0,5.0,0.0,5.0),
                    child:
                    Row(

                        children: <Widget>[

                          SizedBox(
                            width: 3,
                          ),
                              Text("Price",
                                style: GoogleFonts.roboto(
                                  fontSize:16.0,
                                  color: Color(0xFF1f1f1f).withOpacity(0.8),


                                ),),
                        Spacer(),

                              Text('₹'+price.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize:16.0,
                                  color: Color(0xFF1f1f1f).withOpacity(0.8),


                                ),),
                          SizedBox(
                            width: 10,
                          ),

                        ])):Container()
,
                mainData.length>0?Container(
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),

                    margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                    child:
                    Row(

                        children: <Widget>[

                          SizedBox(
                            width: 3,
                          ),
                          Text("Delivery Charges",
                            style: GoogleFonts.roboto(
                              fontSize:16.0,
                              color: Color(0xFF1f1f1f).withOpacity(0.8),


                            ),),
                          Spacer(),

                          Text('₹'+deliveryCharges.toString(),
                            style: GoogleFonts.roboto(
                              fontSize:16.0,
                              color: Color(0xFF1f1f1f).withOpacity(0.8),


                            ),),
                          SizedBox(
                            width: 10,
                          ),

                        ])):Container()
,
                mainData.length>0?Padding(
                  padding: EdgeInsets.fromLTRB(15,10,15,0),
                  child:
                  Divider(

                    height: 1,

                    thickness: 1,
                    color: Color(0xFFc3c3c3),
                  ),):Container(),

                mainData.length>0? Container(
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),

                    margin: EdgeInsets.fromLTRB(0.0,5.0,0.0,100.0),
                    child:
                    Row(

                        children: <Widget>[

                          SizedBox(
                            width: 3,
                          ),
                          Text("Amount Payable",
                            style: GoogleFonts.roboto(
                              fontSize:18.0,
                              color: Color(0xFF1f1f1f).withOpacity(0.8),
                                fontWeight: FontWeight.w700

                            ),),
                          Spacer(),

                          Text('₹'+amountPayable.toString(),
                            style: GoogleFonts.roboto(
                              fontSize:18.0,
                              color: Color(0xFF1f1f1f).withOpacity(0.8),
                                fontWeight: FontWeight.w700

                            ),),
                          SizedBox(
                            width: 10,
                          ),

                        ])):Container()


              ]):Container(
               height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child:_isInAsyncCall?Container():Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      new Image(
        image: new AssetImage("assets/ic_empty_box.png"),
        width: 200,
        height:  200,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      ),
      Text(
        'Your Cart is Empty.',
        style: GoogleFonts.poppins(
          fontSize: ScreenUtil().setSp(24),
          letterSpacing: 1.2,
          color: Colors.black,
          fontWeight: FontWeight.w500,

        ),
      ),
      Text(
        'Please add items to it.',
        style: GoogleFonts.poppins(
          fontSize: ScreenUtil().setSp(14),
          letterSpacing: 1.2,
          color: Colors.black,
          fontWeight: FontWeight.w500,

        ),
      ),
      SizedBox(height: 20),
      _addBooksButton()
    ])


             )

             , mainData.length>0? Align(
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
                           Text('₹'+amountPayable.toString(),
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
             ):Container(),
           ]) ,))

    );
  }

  Widget _addBooksButton() {
    return InkWell(
      onTap: () {

        Navigator.of(context, rootNavigator: true).pop(context);

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
          'Add Books',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(18), color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


  Widget _submitButton() {
    return InkWell(
      onTap: () {
        List<ItemData> order_items= new List();
        for(int i=0;i<mainData.length;i++){
          ItemData itemData=new ItemData();
          itemData.user_id=USER_ID;
          itemData.book_id=mainData[i].books_id.toString();
          itemData.quantity=mainData[i].quantity.toString();
          itemData.book_type_id=mainData[i].book_type_id.toString();
          order_items.add(itemData);
        }


        setState(() {
          _isInAsyncCall = true;
        });

        String json = jsonEncode(order_items);

        addOrderAPI(order_items,user_Token,amountPayable.toString())
            .then((res) async {
          setState(() {
            _isInAsyncCall = false;
          });


          if (res.status == 1) {

            bool isHavePrinted=false;
            for(var i=0;i<mainData.length;i++){
              if(mainData[i].book_type_id==1){

                 isHavePrinted=true;
                 break;

              }
            }
           /* Fluttertoast.showToast(
                msg: "Order generated successfully!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);*/
if(isHavePrinted) {
  Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
      MaterialPageRoute(
          builder: (BuildContext context) {
            return AddShippingAddressPage(amount: amountPayable.toString(),
                orderId: res.data.order.id.toString());
          }
      ));
}else {
  Navigator.of(context, rootNavigator: true).push( // ensures fullscreen
      MaterialPageRoute(
          builder: (BuildContext context) {
            return BookPaymentPage(amount: amountPayable.toString(),
                orderId: res.data.order.id.toString());
          }
      ));
}
          }
          else {
            showAlertDialogValidation(context,"Some error occured!");
          }
        });


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
  Widget _buildList() {
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      itemCount: mainData.length , // Add one more item for progress indicator
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
       /* if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {*/
          return GestureDetector(
              onTap: () =>
              {

              /*  Navigator.of(context, rootNavigator: true)
                    .push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return VideoDetailNewPage(content: mainData[index]);
                        }
                    ))*/
              },
              child:
              _buildBoxBook(context,index, mainData[index].id, mainData[index].title,
                  mainData[index].thumbImage, mainData[index].publisher, mainData[index].cost.toString(),mainData[index].quantity.toString(),mainData[index].actual_cost.toString(),mainData[index].book_type_id,mainData[index].is_ebook_free));



        }
     // }
      ,

    );
  }

   void setValue(int index,String value,String cost,String id){
    int a=int.parse(value);
    int b=int.parse(cost);
    int valueTotal=a*b;

    setState(() {
      _isInAsyncCall = true;
    });
    updateQTYFromCart(id,user_Token,value)
        .then((res) async {
      setState(() {
        _isInAsyncCall = false;
      });


      if (res.status == 1) {
         setState(() {
       mainData[index].quantity=int.parse(value);
       mainData[index].cost= valueTotal;

     });

          int tPrice=0;
         for(int i=0;i<mainData.length;i++){
           tPrice=tPrice+mainData[i].cost;
         }

      setState(() {
      amountPayable=tPrice+deliveryCharges;
      price=tPrice;


      });

      }
      else {
        showAlertDialogValidation(context,"Some error occured!");
      }
    });


  }
  Future<AddToCartResponse> postDeleteFromCart(String id,String token) async {

  //  print('my_token'+token);
  //  var body =json.encode({"book_id":book_id});
    MainRepository repository=new MainRepository();
    return repository.fetchDeleteCartData(id,token);

  }

  Future<AddToCartResponse> updateQTYFromCart(String id,String token,String qty) async {

    //  print('my_token'+token);
    var body =json.encode({"quantity":qty,"id":id});
    MainRepository repository=new MainRepository();
    return repository.fetchUpdateQTYCartData(id,body,token);

  }

  Future<OrderResponse> addOrderAPI(List<ItemData> order_items,String token,String total) async {
  //  final String requestBody = json.encoder.convert(order_items);

    print('my_token'+token);
    var body =json.encode({"total":total,"order_items":order_items});
    MainRepository repository=new MainRepository();
    return repository.fetchAddOrderData(body,token);

  }


  showAlertDialogValidation(BuildContext context,String message) {

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

  Future _asyncInputDialog(BuildContext context,int index,String value,String cost,String id) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Constants.AppName),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Please Enter Qty', ),
                    onChanged: (value) {
                      teamName = value;
                    },
                  ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {

                Navigator.of(context).pop(teamName);
              },
            ),

            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                bool isMatched=false;
                for(int i = 0; i < qtyData.length; i++){

                  if (teamName== qtyData[i]) {
                    setValue(index,teamName,cost,id.toString());
                    isMatched=true;
                    break;
                  }
                }


                if(!isMatched && teamName.isNotEmpty){
                qtyData.add(teamName);
                setValue(index,teamName,cost,id.toString());
                Navigator.of(context).pop(teamName);
                }
                else{
                Navigator.of(context).pop(teamName);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBoxBook(BuildContext context,int index,int id,String title,String thumbnail,String publisher,String cost,String qty,String actualCost,int book_type_id,bool is_ebook_free){

    bool isMatched=false;

    for(int i = 0; i < qtyData.length; i++){

      if (qty== qtyData[i]) {
        isMatched=true;
        break;
      }
    }
    if(!isMatched){
      qtyData.add(qty);
    }

    String bookType="";
    if(book_type_id==1){
      bookType="(Printed)";
    }
    else  if(book_type_id==2){
      bookType="(Online)";
    }
    String offerText="";

    if(book_type_id==1 && is_ebook_free){

      offerText="(Online free in offer)";
    }

  //  title= title.length>25?title=title.substring(0,25)+"...":title;
// print("my_qty--"+qty);

    return   SizedBox(child: Container(
        margin:EdgeInsets.fromLTRB(10.0,12.0,10.0,0.0) ,
      //  height: 185,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
        Container(

        child:
             Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                height: 150,
                width: 100,
                alignment: Alignment.center,

                decoration: BoxDecoration(

                  border: Border.all(color: Colors.black),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(thumbnail),
                  ),
                ),

              ),
    Container(

    child:Expanded( child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(15,4,0,0),
                  child:
                 Text(title,overflow: TextOverflow.ellipsis,
                    maxLines: 3, style: GoogleFonts.poppins(
                      fontSize:14.0,
                      color: Color(0xFF000000).withOpacity(1),
                        fontWeight: FontWeight.w700

                    ),)),

              Padding(
                  padding: EdgeInsets.fromLTRB(15,5,0,0),
                  child: Text(bookType,   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.poppins(
                      fontSize:12.0,
                      color: Color(0xFF000000),
                        fontWeight: FontWeight.w500
                    ),)),
      offerText==""?Container(): Padding(
          padding: EdgeInsets.fromLTRB(15,5,0,0),
          child: Text(offerText,   overflow: TextOverflow.ellipsis,
            maxLines: 1, style: GoogleFonts.poppins(
                fontSize:12.0,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w500
            ),)),
      Padding(
          padding: EdgeInsets.fromLTRB(15,0,0,0),
          child: Text(publisher,   overflow: TextOverflow.ellipsis,
            maxLines: 1, style: GoogleFonts.poppins(
              fontSize:12.0,
              color: Color(0xFF000000),

            ),)),



    SizedBox(

    height: 55, child: Container(
          margin: EdgeInsets.fromLTRB(5.0,20.0,20.0,0.0),

          child:
          Row(

              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10,0,0,0),
                    child: Text('₹' +actualCost.toString()+'/-',
                      maxLines: 1, style: GoogleFonts.roboto(
                          fontSize:23.0,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold

                      ),)),
                Spacer(),

                book_type_id==1?  Padding(
    padding: EdgeInsets.fromLTRB(10,0,0,0),
    child:
    Container(
    height: 35,
    width: 105,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.orange,   width: 1.3, ),
    ),

    child:DropdownButtonHideUnderline(

    child: Theme(
    data: new ThemeData(
    primaryColor: Colors.orange,
    ),
    child:
               DropdownButton<String>(

                  icon: Icon(Icons.arrow_drop_down, color: Colors.orange,),

                  value: qty,

                 onChanged: (value) => {


                   if(value=='more'){
                     _asyncInputDialog(context,index,value,actualCost,id.toString())
                   }
                   else{
    setValue(index,value,actualCost,id.toString())
    }


                 }


                 ,

                  selectedItemBuilder: qty == null
                      ? null
                      : (BuildContext context) {
                    return qtyData.map((String value) {

                      return  Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Text("Qty : "+value,
                              style: TextStyle(fontSize: 15, color: Colors.black)));
                    }).toList();
                  },
                  items: qtyData.map((String title) {
                    int value=0;
                    if(title=='more'){
                      value=0;
                    }
                    else{
                       value= int.parse(title);
                    }


                    return new DropdownMenuItem<String>(

                      value: title,
                      child: value>5?Text("",style:TextStyle(height: 0),):new Text(
                        title,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),

    )),

    ),
    ):Container(),






              ])))


            ])))
            ])),


    Container(
      width:MediaQuery.of(context).size.width ,

    margin: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
    child:
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[

    InkWell(
    onTap: () {

     setState(() {
        _isInAsyncCall = true;
      });
      postDeleteFromCart(id.toString(),user_Token)
          .then((res) async {
       setState(() {
          _isInAsyncCall = false;
        });


        if (res.status == 1) {
          eventBus.fire(OnCartCount("FIND"));
          Fluttertoast.showToast(
              msg: "Cart item has been deleted !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            mainData.removeAt(index);
            
          });
          int tPrice=0;
          for(int i=0;i<mainData.length;i++){
            tPrice=tPrice+mainData[i].cost;
          }

          setState(() {
            amountPayable=tPrice+deliveryCharges;
            price=tPrice;


          });


        }
        else {
          showAlertDialogValidation(context,"Some error occured!");
        }
      });


    },child:Container(
        padding: EdgeInsets.fromLTRB(10.0,6.0,10.0,6.0),
          decoration: BoxDecoration(

            border: Border.all(color: Colors.black),

          ),
          margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
          child:
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Icon(Icons.delete,color: Colors.red,size: 18,),
                SizedBox(
                  width: 3,
                ),
               Text("Remove",
                style: GoogleFonts.roboto(
               fontSize:16.0,
               color: Color(0xFF010101),
               fontWeight: FontWeight.w500

               ),),

              ])))
,
      SizedBox(
        width: 15,
      ),
    InkWell(
    onTap: () {




    },child:
      Container(
          padding: EdgeInsets.fromLTRB(10.0,6.0,10.0,6.0),
          margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
          decoration: BoxDecoration(

            border: Border.all(color: Colors.black),

          ),
          child:
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add,color: Colors.green,size: 20,),
                SizedBox(
                  width: 3,
                ),
                Text("Add more books",
                  style: GoogleFonts.roboto(
                      fontSize:16.0,
                      color: Color(0xFF010101),
                      fontWeight: FontWeight.w500

                  ),),


              ])))


    ])),

              SizedBox(
                height: 15,
              ),
                 Divider(

                    height: 1,

                    thickness: 1,
                    color: Color(AppColors.textBaseColor),
                  )

            ]
        )));
  }
}