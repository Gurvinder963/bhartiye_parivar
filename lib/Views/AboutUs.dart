import 'dart:convert';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../ApiResponses/AboutUsResponse.dart';
import '../Repository/MainRepository.dart';
import '../Utils/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:drop_cap_text/drop_cap_text.dart';

class AboutUsPage extends StatefulWidget {


final String channelId;
 AboutUsPage({Key key,@required this.channelId}) : super(key: key);

  @override
  AboutUsPageState createState() {
    return AboutUsPageState(channelId);
  }
}

class AboutUsPageState extends State<AboutUsPage> {

String channelId;
AboutUsPageState(channelId){
this.channelId=channelId;

}

  // WebViewController _controller;
  List list_product;

  String user_Token;
  //bool isBookMarked = false;
  // bool isSubscribed= false;
  bool _isInAsyncCall = false;
  bool _isPlayerReady = false;
  String USER_ID;

  Future<AboutUsResponse> getFaqList(String user_Token) async {
    print("-0-0-0");
    print(USER_ID);
    // String pageIndex = page.toString();
    var body = json.encode({
      "app_code": Constants.AppCode,
      "channel_id": channelId,
      "token": user_Token,
      "userid": USER_ID,
      "page_no": "1"
    });
    MainRepository repository = new MainRepository();
    return repository.fetchAboutUsJAVA(body);
  }

  @override
  void initState() {
    super.initState();
    list_product = new List();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {
      user_Token = prefs.getString(Prefs.KEY_TOKEN);
      USER_ID = prefs.getString(Prefs.USER_ID);

      getFaqList(user_Token).then((value) async {
        setState(() {
          // isLoading = false;
          // mainData.addAll(value.faqs);

          for (var k = 0; k < value.data.length; k++) {
            Map map = Map();
            map.putIfAbsent(value.data[k].header, () => value.data[k].content);
            list_product.add(map);
          }
          list_product.map((s) {}).map((list) => list).toList();
        });
      });

      return (prefs.getString('token'));
    });
  }

  @override
  Widget build(BuildContext context) {
    List list = List();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('About Us'),
      ),
      body: Center(
          child: ListView(
        children: [
          for (final map in list_product)
            for (final keys in map.keys) ListItem(keys, map[keys].toList()),
        ],
      )),
    );
  }

  String getMonth(int month) {
    switch (month) {
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

  List getWeeks(
      String content1, String content2, String content3, String content4) {
    List listItems = new List();

    listItems.add(content1);
    listItems.add(content2);
    listItems.add(content3);
    listItems.add(content4);

    return listItems;
  }
}

class ListItem extends StatefulWidget {
  List listItems;
  String headerTitle;

  ListItem(headerTitle, listItems) {
    this.listItems = listItems;
    this.headerTitle = headerTitle;
  }

  @override
  State createState() {
    return ListItemState(headerTitle, listItems);
  }
}

class ListItemState extends State {
  List listItems;
  String headerTitle;
  ListItemState(headerTitle, listItems) {
    this.listItems = listItems;
    this.headerTitle = headerTitle;
  }

  bool isExpand = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpand = false;
  }

  Widget _buildBoxVideo(BuildContext context, String url) {
    String html;
    var videoIdd;
    try {
      videoIdd = YoutubePlayer.convertUrlToId(url);
      print('this is ' + videoIdd);
    } on Exception catch (exception) {
      // only executed if error is of type Exception
      print('exception');
    } catch (error) {
      // executed for errors of all types other than Exception
      print('catch error');
      //  videoIdd="error";

    }
    html =
        '''<iframe id="player" width="100%" height="100%" style ="padding: 0px;position: relative; padding-top: 0px;height: 0;
            overflow: hidden;" type="text/html"
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=true"
  frameborder="1"></iframe>
     ''';

    return  AspectRatio(
                      aspectRatio: 16 / 9,
                      child:HtmlWidget(
      html,
      // ignore: deprecated_member_use
      webView: true,
      // ignore: deprecated_member_use
    ));
  }

  @override
  Widget build(BuildContext context) {
    List listItem = listItems;
    return Padding(
      padding: (isExpand == true)
          ? const EdgeInsets.all(8.0)
          : const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: ExpansionTile(
          key: PageStorageKey(headerTitle),
          title: Container(
              width: double.infinity,
              child: Text(
                headerTitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: (isExpand != true) ? 17 : 17),
              )),
          trailing: (isExpand == true)
              ? Icon(
                  Icons.horizontal_rule,
                  size: 32,
                  color: Colors.orange,
                )
              : Icon(Icons.add, size: 32, color: Colors.orange),
          onExpansionChanged: (value) {
            setState(() {
              isExpand = value;
            });
          },
          children: [
            for (final item in listItem)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.pink,
                          duration: Duration(microseconds: 500),
                          content: Text("Selected Item $item " + headerTitle)));
                    },
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xFF81c784),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.white)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item.subHeader,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            item.fullPictureTop != null &&
                                    item.fullPictureTop.isNotEmpty
                                ? AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 0.0),

                                      alignment: Alignment.center,
                                      // height: ScreenUtil().setHeight(175),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              NetworkImage(item.fullPictureTop),
                                        ),
                                      ),
                                    ))
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            item.fullPictureTopCaption != null &&
                                    item.fullPictureTopCaption.isNotEmpty
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.fullPictureTopCaption,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            item.videoUrlTop != null &&
                                    item.videoUrlTop.isNotEmpty
                                ? _buildBoxVideo(context, item.videoUrlTop)
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            
                            item.paraText != null &&
                                    item.paraText.isNotEmpty && item.leftPictureTop.isEmpty && item.rightPictureTop.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.paraText,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ):Container(
                                    height: 0,
                                    width: 0,
                                  ),

                            item.leftPictureTop != null &&
                                    item.leftPictureTop.isNotEmpty
                                ? DropCapText(
                                    item.paraText,
                                    dropCapPosition: DropCapPosition.start,
                                    textAlign: TextAlign.justify,
                                    dropCap: DropCap(
                                        width: 100,
                                        height: 120,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                           
                                                    Container(height:90 , child:Image.network(
                                                        item.leftPictureTop)),
                                                    item.leftPictureTopCaption !=
                                                                null &&
                                                            item.leftPictureTopCaption
                                                                .isNotEmpty
                                                        ?  Flexible(
                                                            child: Text(
                                                              item.leftPictureTopCaption,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 0,
                                                            width: 0,
                                                          ),
                                                  ],
                                               
                                             
                                            )),
                                  )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),


  item.rightPictureTop != null &&
                                    item.rightPictureTop.isNotEmpty
                                ? DropCapText(
                                    item.paraText,
                                    dropCapPosition: DropCapPosition.end,
                                    textAlign: TextAlign.justify,
                                    dropCap: DropCap(
                                        width: 100,
                                        height: 120,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                           
                                                    Container(height:90 , child:Image.network(
                                                        item.rightPictureTop)),
                                                    item.rightPictureTopCaption !=
                                                                null &&
                                                            item.rightPictureTopCaption
                                                                .isNotEmpty
                                                        ?  Flexible(
                                                            child: Text(
                                                              item.rightPictureTopCaption,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 0,
                                                            width: 0,
                                                          ),
                                                  ],
                                               
                                             
                                            )),
                                  )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),


                            item.videoUrlBottom != null &&
                                    item.videoUrlBottom.isNotEmpty
                                ? _buildBoxVideo(context, item.videoUrlBottom)
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            item.fullPictureBottom != null &&
                                    item.fullPictureBottom.isNotEmpty
                                ? AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 0.0),

                                      alignment: Alignment.center,
                                      // height: ScreenUtil().setHeight(175),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              item.fullPictureBottom),
                                        ),
                                      ),
                                    ))
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            item.fullPictureBottomCaption != null &&
                                    item.fullPictureBottomCaption.isNotEmpty
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.fullPictureBottomCaption,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                          ],
                        ))),
              )
          ],
        ),
      ),
    );
  }
}
