import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyBooksTab.dart';
import 'BooksByLanguage.dart';
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
import 'package:bhartiye_parivar/Utils/constants.dart';
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

  String user_Token;
  @override
  void initState() {
    super.initState();

    qtyData.add('1');
    qtyData.add('2');
    qtyData.add('3');
    qtyData.add('more');

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

       user_Token=prefs.getString(Prefs.KEY_TOKEN);
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}

      getBooksList(user_Token).then((value) => {

        setState(() {
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
          title: Text('Cart', style: GoogleFonts.poppins(fontSize: 22,color: Color(0xFFFFFFFF))),

        ),
        body:   Container(

           child: Stack(  children: [

        ListView(


              children: <Widget>[

                   _buildList(),



                Padding(
                    padding: EdgeInsets.fromLTRB(15,0,0,0),
                    child:
                    Text("PRICE DETAILS",
                      maxLines: 1, style: GoogleFonts.poppins(
                          fontSize:18.0,
                          color: Color(0xFF393939).withOpacity(0.8),


                      ),)),
                Padding(
                    padding: EdgeInsets.fromLTRB(15,20,15,0),
                    child:
                    Divider(

                      height: 1,

                      thickness: 1,
                      color: Color(0xFFc3c3c3),
                    ),),


                Container(
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),

                    margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
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

                              Text('₹'+"230",
                                style: GoogleFonts.roboto(
                                  fontSize:16.0,
                                  color: Color(0xFF1f1f1f).withOpacity(0.8),


                                ),),
                          SizedBox(
                            width: 10,
                          ),

                        ]))
,
                Container(
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

                          Text('₹'+"20",
                            style: GoogleFonts.roboto(
                              fontSize:16.0,
                              color: Color(0xFF1f1f1f).withOpacity(0.8),


                            ),),
                          SizedBox(
                            width: 10,
                          ),

                        ]))
,
          Divider(

            height: 1,

            thickness: 1,
            color: Color(0xFFc3c3c3),
          ),

        Container(
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),

                    margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,100.0),
                    child:
                    Row(

                        children: <Widget>[

                          SizedBox(
                            width: 3,
                          ),
                          Text("Amount Payable",
                            style: GoogleFonts.roboto(
                              fontSize:16.0,
                              color: Color(0xFF1f1f1f).withOpacity(0.8),
                                fontWeight: FontWeight.w700

                            ),),
                          Spacer(),

                          Text('₹'+"250",
                            style: GoogleFonts.roboto(
                              fontSize:16.0,
                              color: Color(0xFF1f1f1f).withOpacity(0.8),
                                fontWeight: FontWeight.w700

                            ),),
                          SizedBox(
                            width: 10,
                          ),

                        ]))


              ])

             ,Align(
               alignment: FractionalOffset.bottomCenter,
               child:    GestureDetector(
                   onTap: () {


                   },child:Container(
                 height: 60,
                 width: MediaQuery.of(context).size.width,
                 color: Colors.white,
                 padding: EdgeInsets.fromLTRB(0,8,0,8),
                 child:   Row(

                     children: <Widget>[

                       SizedBox(
                         width: 10,
                       ),
                       Text('₹'+"250",
                         style: GoogleFonts.roboto(
                             fontSize:16.0,
                             color: Color(0xFF1f1f1f).withOpacity(0.8),
                             fontWeight: FontWeight.w700

                         ),),
                       Spacer(),

                       _submitButton(),
                       SizedBox(
                         width: 10,
                       ),

                     ]),


               )),
             ),
           ]) ,)

    );
  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {




      },

      child: Container(
        width: 150,
        height: ScreenUtil().setWidth(40),

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
          'Place Order',
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  Widget _buildList() {
    return ListView.builder(
      itemCount: mainData.length+ 1 , // Add one more item for progress indicator
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {
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
                  mainData[index].thumbImage, mainData[index].publisher, mainData[index].cost.toString(),mainData[index].qty,mainData[index].totalCost));



        }
      },

    );
  }

   void setValue(int index,String value,String cost){
    int a=int.parse(value);
    int b=int.parse(cost);
    int valueTotal=a*b;

     setState(() {
       mainData[index].qty=value;
       mainData[index].totalCost= valueTotal;

     });
  }
  Future<AddToCartResponse> postDeleteFromCart(String book_id,String token) async {

  //  print('my_token'+token);
  //  var body =json.encode({"book_id":book_id});
    MainRepository repository=new MainRepository();
    return repository.fetchDeleteCartData(book_id,token);

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
  Widget _buildBoxBook(BuildContext context,int index,int id,String title,String thumbnail,String publisher,String cost,String qty,int totalCost){

 print("my_qty--"+qty);

    return    Container(
        margin:EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0) ,
        height: 180,
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
                margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                height: 120,
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

    child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(10,4,0,0),
                  child:
                  Text(title,   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.poppins(
                      fontSize:14.0,
                      color: Color(0xFF000000).withOpacity(1),
                        fontWeight: FontWeight.w700

                    ),)),

              Padding(
                  padding: EdgeInsets.fromLTRB(10,5,0,0),
                  child: Text(publisher,   overflow: TextOverflow.ellipsis,
                    maxLines: 1, style: GoogleFonts.poppins(
                      fontSize:12.0,
                      color: Color(0xFF000000),

                    ),)),

      Container(
          margin: EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
          child:
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
    Padding(
    padding: EdgeInsets.fromLTRB(10,0,10,0),
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
                   setValue(index,value,cost)



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

                    return new DropdownMenuItem<String>(
                      value: title,
                      child: new Text(
                        title,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),

    )),

    ),
    ),



                Padding(
                    padding: EdgeInsets.fromLTRB(10,5,0,0),
                    child: Text('₹' +totalCost.toString()+'/-',
                      maxLines: 1, style: GoogleFonts.roboto(
                        fontSize:23.0,
                        color: Color(0xFF000000),
                          fontWeight: FontWeight.bold

                      ),)),


              ]))


            ]))
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

     /* setState(() {
        _isInAsyncCall = true;
      });*/
      postDeleteFromCart(id.toString(),user_Token)
          .then((res) async {
       /* setState(() {
          _isInAsyncCall = false;
        });*/


        if (res.status == 1) {


    setState(() {
  mainData.removeAt(index);
    });


        }
        else {
          showAlertDialogValidation(context,"Some error occured!");
        }
      });


    },child:Container(
        padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),
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
               fontSize:15.0,
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
          padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),
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
                      fontSize:15.0,
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
        ));
  }
}