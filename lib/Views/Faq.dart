import 'dart:convert';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../ApiResponses/FaqDataResponse.dart';
import '../Repository/MainRepository.dart';
import '../Utils/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';

class FaqPage extends StatefulWidget {
  @override
  FaqPageState createState() {
    return FaqPageState();
  }
}

class FaqPageState extends State<FaqPage> {
  // WebViewController _controller;
  List list_product;

  String user_Token;
  //bool isBookMarked = false;
  // bool isSubscribed= false;
  bool _isInAsyncCall = false;
  bool _isPlayerReady = false;
  String USER_ID;

  Future<FaqDataResponse> getFaqList(String user_Token) async {


    // String pageIndex = page.toString();
    var body =json.encode({"appcode":Constants.AppCode, "token": user_Token,"userid": USER_ID,"page":"1"});
    MainRepository repository=new MainRepository();
    return repository.fetchFaqsListJAVA(body);




  }



  @override
  void initState() {
    super.initState();
    list_product=new List();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);

      getFaqList(user_Token).then((
          value) async {

        setState(() {
          // isLoading = false;
          // mainData.addAll(value.faqs);


          for(var k=0;k<value.faqs.length;k++)
          {
            Map map=Map();
            map.putIfAbsent(value.faqs[k].question, ()=>getWeeks(value.faqs[k].answer));
            list_product.add(map);

          }
          list_product.map((s){

          }).map((list)=>list).toList();



        });



      });




      return (prefs.getString('token'));
    });



  }

  @override
  Widget build(BuildContext context) {
    List list=List();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('FAQ'),
      ),
      body: Center(

          child: ListView(
            children: [
              for(final map in list_product)
                for(final keys in map.keys)
                  ListItem(keys,map[keys].toList())
              ,
            ],
          )
      ),

    );
  }
  String getMonth(int month)
  {
    switch(month)
    {
      case 1:
        return "1. Early life,family and education";
      case 2:
        return "2. Early life,family and education";
      case 3:
        return "3. Early life,family and education";
      case 4:
        return "4. Early life,family and education";
      case 5:
        return "5. Early life,family and education";
      case 6:
        return "6. Early life,family and education";

    }
  }

  List getWeeks(String answer)
  {
    List listItems=new List();
    listItems.add(answer);

    return listItems;
  }
}
class ListItem extends StatefulWidget{

  List listItems;
  String headerTitle;

  ListItem(headerTitle,listItems){
    this.listItems=listItems;
    this.headerTitle=headerTitle;
  }

  @override
  State createState()
  {
    return ListItemState(headerTitle,listItems);
  }


}
class ListItemState extends State
{
  List listItems;
  String headerTitle;
  ListItemState(headerTitle,listItems){
    this.listItems=listItems;
    this.headerTitle=headerTitle;
  }

  bool isExpand=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpand=false;
  }
  @override
  Widget build(BuildContext context) {

    List listItem=listItems;
    return  Padding(
      padding: (isExpand==true)?const EdgeInsets.all(8.0):const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: ExpansionTile(
          key: PageStorageKey(headerTitle),
          title: Container(

              width: double.infinity,

              child: Text(headerTitle,style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black, fontSize: (isExpand!=true)?17:17),)),
          trailing: (isExpand==true)?Icon(Icons.arrow_drop_up,size: 32,color: Colors.orange,):Icon(Icons.arrow_drop_down,size: 32,color: Colors.orange),
          onExpansionChanged: (value){
            setState(() {
              isExpand=value;
            });
          },
          children: [
            for(final item in listItem)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Scaffold.of(context).showSnackBar(SnackBar(backgroundColor: Colors.pink,duration:Duration(microseconds: 500),content: Text("Selected Item $item "+headerTitle )));
                  },
                  child: Container(
                      width: double.infinity,
                      decoration:BoxDecoration(

                          color:Color(0xFF81c784),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.white)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item,style: TextStyle(color: Colors.white),),
                      )),
                ),
              )


          ],

        ),
      ),
    );
  }
}
