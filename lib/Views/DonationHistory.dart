import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Repository/MainRepository.dart';
import'../ApiResponses/DonateHistoryResponse.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationHistoryPage extends StatefulWidget {
  @override
  DonationHistoryPageState createState() {
    return DonationHistoryPageState();
  }
}

class DonationHistoryPageState extends State<DonationHistoryPage> {
  String user_Token;
  List mainData = new List();
  bool isLoading = false;
  bool _isInAsyncCall = false;
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);


        setState(() {
          _isInAsyncCall = true;
        });
      getDonationList(user_Token).then((value) => {

          setState(() {

            _isInAsyncCall = false;
            mainData.addAll(value.data);

          })

        });


      return (prefs.getString('token'));
    });

  }

  Future<DonateHistoryResponse> getDonationList(String user_Token) async {

    var body ={'lang_code':""};
    MainRepository repository=new MainRepository();
    return repository.fetchDonationHistoryData(body,user_Token);

  }

  Widget _buildList() {


    return

        ListView.builder(
          itemCount: mainData.length , // Add one more item for progress indicator

          itemBuilder: (BuildContext context, int index) {
           var dte= mainData[index].createdAt.toString().split(" ");
              return GestureDetector(
                  onTap: () =>
                  {


                  },
                  child:Container(
                  child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(10,10,10,10),

              child:
                      Row(


                      children: <Widget>[
                      Text("Date: "+dte[0],   overflow: TextOverflow.ellipsis,
                        maxLines: 1, style: GoogleFonts.roboto(
                        fontSize:15.0,
                        color: Color(0xFF5a5a5a),

                      ),)
                        ,
                        Spacer(),
                        Text("Amount: ₹"+mainData[index].amount+"/-",   overflow: TextOverflow.ellipsis,
                          maxLines: 1, style: GoogleFonts.roboto(
                            fontSize:15.0,
                            color: Color(0xFF5a5a5a),

                          ),),
                      ])),
                  Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,10),

                      child:
              Row(


                  children: <Widget>[
                    Text("To: Bhartiya Parivar",   overflow: TextOverflow.ellipsis,
                      maxLines: 1, style: GoogleFonts.roboto(
                        fontSize:15.0,
                        color: Color(0xFF5a5a5a),

                      ),),
                    Spacer(),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                        child: GestureDetector(
                            onTap: () {

                             // _requestDownload(orderId,id.toString());
                              // _prepare();
                            },child: Container(
                            decoration: BoxDecoration(
                                color: Color(AppColors.BaseColor),
                                border: Border.all(color: Colors.black)
                            ),
                            padding: EdgeInsets.fromLTRB(5,3,5,3),

                            child:Text("Download Invoice",overflow: TextOverflow.ellipsis,
                              maxLines: 1, style: GoogleFonts.poppins(
                                fontSize:12.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),

                              ),)))),
                  ]))
, Divider(
                color: Colors.grey,
              ),
                      ])


                  )



              );

          },



      );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text("Donation History"),
      ),
      body:  ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child: Container(

        child:Expanded(
          child: _buildList(),

        )

    )),

    );
  }


}