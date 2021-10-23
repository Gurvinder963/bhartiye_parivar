import 'dart:convert';
import '../localization/locale_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Views/html_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:polls/polls.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../Utils/AppColors.dart';
import '../Interfaces/OnNewsBack.dart';
import '../Views/CustomPageViewScrollPhysics.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_embed_webview/social_embed_webview.dart';
import 'package:social_embed_webview/platforms/twitter.dart';
import '../ApiResponses/NewsResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/NewsData.dart';
import '../ApiResponses/AddToCartResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../ApiResponses/BookMarkSaveResponse.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
class NewsMainPage extends StatefulWidget {
  @override
  NewsMainPageState createState() {
    return NewsMainPageState();
  }
}

class NewsMainPageState extends State<NewsMainPage> {
  PageController controller=PageController();
  int selectedRadio = 0;
  int selectedRadioTile = 0;
  bool isBookMarked=false;
  int mPagePosition=0;
  var likeStatus=0;
  int page = 1;
  int _curr=0;
 // int mposition=0;
  Future<BookMarkSaveResponse> postAddBookMark(String content_type,String token,String content_id) async {
    String status = "0";
    if (isBookMarked) {
      status = "0";

    } else {

      status = "1";
    }
    print('my_token'+token);
    var body =json.encode({"content_type": content_type, "content_id": content_id,"bookmark_type": status});
    MainRepository repository=new MainRepository();
    return repository.fetchAddBookMark(body,token);

  }

  Future<NewsResponse> getNewsList(String user_Token) async {
    String pageIndex = page.toString();
    String perPage = "10";
    var body ={'lang_code':'','page': pageIndex,
      'per_page': perPage,};
    MainRepository repository=new MainRepository();
    return repository.fetchNewsData(body,user_Token);

  }
  List mainData = new List();
  bool isLoading = false;
  bool _isInAsyncCall = false;
  String user_Token;
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      apiCall();

      return (prefs.getString('token'));
    });

  }


  void apiCall(){
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });}
    getLocaleContentLang().then((locale) {

      if(locale==null){
        locale="";
      }

      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}

      getNewsList(user_Token).then((value) => {
        if(value.data.length>0 && page==1){
          setState(()
          {
            isBookMarked = value.data[0].bookmark;
            likeStatus=value.data[0].is_like;
          })
        },
        setState(() {
          isLoading = false;
          mainData.addAll(value.data);
          if (!mainData.isEmpty) {
            page++;
          }

        }),



      });



    });

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





 /* Widget _buildBoxMultipleImagesList(BuildContext context,NewsData newsData,List<EmbedUrls> embedUrls){


    PageController controller1=PageController();

    var newsArr=newsData.createdAt.split(" ");

    return
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Stack(
                children: <Widget>[
                  Container(
                      height:  MediaQuery.of(context).size.height*0.30,
                      color: Colors.black,
                      child:
                      PageView.builder(
                        controller: controller1,
                        scrollDirection: Axis.horizontal,
                        itemCount:embedUrls.length,
                        onPageChanged: (int position) {
                          setState(() {
                            mposition=position;
                          });



                        },
                        itemBuilder: (BuildContext context, int position)
                        {
                          print("my_pos"+position.toString());


                          return
                            Container(
                              margin: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),

                              alignment: Alignment.center,

                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(embedUrls[position].url),

                                  alignment: Alignment.center,
                                ),

                              ),

                            );



                        },


                      )),
                  Positioned.fill(
                      child:Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10,3,10,5),
                              margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                              color:  Color(0xFF5a5a5a),
                              child: Text((mposition+1).toString()+"/"+embedUrls.length.toString(),  style: GoogleFonts.roboto(
                                fontSize:14.0,

                                color: Colors.white,
                                fontWeight: FontWeight.w500,

                              ),))


                      )),
                ]),
            Padding(
                padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text(newsData.title,style:  GoogleFonts.poppins(
                fontSize: 18,fontWeight:FontWeight.w500),)),
            Divider(
              color: Colors.black,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text(newsData.description,style:  GoogleFonts.roboto(
                fontSize: 16,fontWeight:FontWeight.w500),)),

            Row(
                children:<Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text(newsArr[0],style:  GoogleFonts.poppins(
                      fontSize: 16,fontWeight:FontWeight.w500),)),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text("Read More >",style:  GoogleFonts.poppins(color: Colors.orange,
                      fontSize: 16,fontWeight:FontWeight.w500),)),


                ]

            ),

          ]
      );

  }*/
  Future<ShortDynamicLink> getShortLink(int id) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://bhartiyeparivar.page.link',
        link: Uri.parse('https://bhartiyeparivar.page.link/content?contentId=' +
            id.toString() +
            '&contentType=news'),
        //  link: Uri.parse('https://play.google.com/store/apps/details?id=com.nispl.studyshot&invitedby='+referral_code),
        androidParameters: AndroidParameters(
          packageName: 'com.bhartiyeparivar',
        ),
        iosParameters: IosParameters(
          bundleId: 'com.example',
          minimumVersion: '1.0.1',
          appStoreId: '1405860595',
        ));

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    return shortDynamicLink;
  }
  _onShare(BuildContext context,String title,String thumbnail) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    // final RenderBox box = context.findRenderObject() as RenderBox;
  //  var url = thumbnail;
   // var response = await get(url);
  //  final documentDirectory = (await getExternalStorageDirectory()).path;
  //  File imgFile = new File('$documentDirectory/flutter.png');
  //  imgFile.writeAsBytesSync(response.bodyBytes);
    List<String> imagePaths = [];
  //  imagePaths.add('$documentDirectory/flutter.png');

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
        text: title,

      );
    } else {
      await Share.share(title,

      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return /*WillPopScope(
        onWillPop: () {
      print('Backbutton pressed (device or appbar button), do whatever you want.');
      print("On bottom back clicked");

      //trigger leaving and use own data
      Navigator.pop(context, false);


      eventBus1.fire(OnNewsBack("FIND"));
      //we need to return a future
      return Future.value(false);
    },
    child:*/Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('News', style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),
        actions: <Widget>[

          IconButton(
              icon: isBookMarked?  Icon(Icons.bookmark_outlined,color: Colors.white,size: 28,):  Icon(Icons.bookmark_border_outlined,size: 25,),
              onPressed: () {
                setState(() {
                  _isInAsyncCall = true;
                });

                postAddBookMark("2",user_Token,mainData[mPagePosition].id.toString())
                    .then((res) async {
                  setState(() {
                    _isInAsyncCall = false;
                  });


                  String mmsg="";
                  if (res.bookmarkType == 1) {

                    mmsg="Bookmark added!";

                    setState(() {
                      isBookMarked = true;
                    });

                  }
                  else {
                    mmsg="Bookmark removed!";
                    setState(() {
                      isBookMarked = false;
                    });
                  }


                  Fluttertoast.showToast(
                      msg: mmsg,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);

                });

                //  submitFavourite("1",tok,MyContentId.toString(),false);
              }),

          SizedBox(
            width: 5,
          ),

        ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
              print("On tap back clicked"),
            eventBus1.fire(OnNewsBack("FIND")),
            //  Navigator.of(context).pop()
            },
          )
      ),
      body:  ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:Column (

          children: [

            Expanded(child:Container(

                child:new PreloadPageView.builder(
                  onPageChanged: (position) {
                    mPagePosition=position;
                    setState(() {
                      isBookMarked = mainData[position].bookmark;
                      likeStatus = mainData[position].is_like;
                    });

                    if (position == mainData.length - 1) {
                    apiCall();
                    }
                  },
                  scrollDirection: Axis.vertical,
                    itemCount:mainData.length,
                    itemBuilder: (BuildContext context, int position)
                        {
                        if (position == mainData.length) {
                        return _buildProgressIndicator();
                        } else {
                          print("my_pos"+position.toString());
                          Widget wid;
                          if(mainData[position].newsType==1){
                            wid=
                                MultipleImagesPage(newsData: mainData[position],embedUrls:mainData[position].embedUrls);
                          }
                          else if(mainData[position].newsType==2){
                            wid= _buildBoxVideo(context,mainData[position],mainData[position].embedUrls);
                          }
                          else if(mainData[position].newsType==3){
                            wid=  _buildBoxTweet(context,mainData[position].embedUrls);
                          }
                          else if(mainData[position].newsType==4){

                          }
                          else if(mainData[position].newsType==5){
                            wid=  _buildBoxPotraitImage(context,mainData[position].embedUrls);
                          }
                          else if(mainData[position].newsType==6){
                            wid=  _buildBoxPoll(context,mainData[position]);
                          }

                          return wid;
                        }},

                    preloadPagesCount: 3,
                    controller: PreloadPageController(),
    ))),
       SizedBox(
              height: 50 ,
              child:Column ( children: <Widget>[
            Divider(
            height: 0.5,
            thickness: 0.6,
            color: Colors.black,
          ),
            Container(
              margin:  EdgeInsets.fromLTRB(10,0,10,0),
              child:Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 2,),
                    IconButton(
                      iconSize: 24,
                        icon: likeStatus==1? Image(
                          image: new AssetImage("assets/like_sel.png"),
                          width: 24,
                          height:  24,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ) :Image(
                          image: new AssetImage("assets/like_unsel.png"),
                          width: 24,
                          height:  24,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                        onPressed: () {
                          setState(() {
                            if(likeStatus==1){
                              likeStatus = 0;
                              mainData[mPagePosition].is_like=likeStatus;
                            }
                            else{
                              likeStatus = 1;
                              mainData[mPagePosition].is_like=likeStatus;
                            }

                          });

                          postAddLike("2",user_Token,mainData[mPagePosition].id.toString())
                              .then((res) async {
                            String msg="";
                            if(likeStatus==1){
                              msg="Added to liked news";
                            }
                            else{
                              msg="Removed from liked news";
                            }
                            Fluttertoast.showToast(
                                msg: msg,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);

                          });

                        }),
                    SizedBox(width: 2,),
                    IconButton(
                        iconSize: 24,
                        icon: likeStatus==2? Image(
                          image: new AssetImage("assets/dislike_sel.png"),
                          width: 24,
                          height:  24,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ) :Image(
                          image: new AssetImage("assets/dislike_unsel.png"),
                          width: 24,
                          height:  24,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                        onPressed: () {

                          setState(() {
                            if(likeStatus==2){
                              likeStatus = 0;
                              mainData[mPagePosition].is_like=likeStatus;
                            }
                            else{
                              likeStatus = 2;
                              mainData[mPagePosition].is_like=likeStatus;
                            }

                          });



                          postAddLike("2",user_Token,mainData[mPagePosition].id.toString())
                              .then((res) async {
                            String msg="";
                            if(likeStatus==2){
                              msg="You Dislike this news";
                            }
                            else{
                              msg="Dislike Removed";
                            }
                            Fluttertoast.showToast(
                                msg: msg,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);

                          });

                        }),
                    SizedBox(width: 2,),
                    IconButton(
                        iconSize: 24,
                        icon: Icon(Icons.report_outlined,size: 28,color:Colors.black,),

                        onPressed: () {
                          _asyncInputDialog(context,mainData[mPagePosition].id.toString());

                          //  submitFavourite("1",tok,MyContentId.toString(),false);
                        }),
                    SizedBox(width: 2,),
                    IconButton(
                        iconSize: 24,
                        icon:Image(
                          image: new AssetImage("assets/share.png"),
                          width: 23,
                          height:  23,
                          color:Colors.black,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                        onPressed: () {
                          getShortLink(mainData[mPagePosition].id).then((res) {
                            setState(() {
                              _isInAsyncCall = false;
                            });
                            var url = res.shortUrl.toString();

                            _onShare(context,mainData[mPagePosition].title +
                                ' ' +
                                url,"");





                          });

                          //  submitFavourite("1",tok,MyContentId.toString(),false);
                        }),
                    SizedBox(width: 17,),

               /*     Image(
                      image: new AssetImage("assets/bookmark_unsel.png"),
                      width: 24,
                      height:  24,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),*/
                    //  Icon(Icons.bookmark_outline_outlined,size: 28,color: Color(0xFF666666),),
                  SizedBox(width: 5,),
                  ]))]))


      ])),

    );
  }
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }
  Future _asyncInputDialog(BuildContext context,String id) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report News"),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            child: SizedBox(
              height: 250,
              width: 400,
              child: new TextField(
                autofocus: false,
                maxLines: 500,
                onChanged: (value) {
                  teamName = value;
                },
                decoration: new InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),

                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  hintText: 'Enter your report reason here',
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {

                Navigator.of(context).pop(teamName);
              },
            ),

            FlatButton(
              child: Text('REPORT'),
              onPressed: () {
                setState(() {
                  _isInAsyncCall = true;
                });
                Navigator.of(context).pop(teamName);
                saveReportAPI(id,teamName).then((res) async {
                  String msg;
                  setState(() {
                    _isInAsyncCall = false;
                  });
                  Fluttertoast.showToast(
                      msg: "Report save successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);

                });
              },
            ),
          ],
        );
      },
    );
  }
  Future<AddToCartResponse> saveReportAPI(id,message) async {
    //  final String requestBody = json.encoder.convert(order_items);


    var body =json.encode({"content_id":id.toString(),"content_type":"2","message":message});
    MainRepository repository=new MainRepository();

    return repository.fetchReportSave(body,user_Token);


  }
  Future<AddToCartResponse> postAddLike(String content_type,String token,String content_id) async {

    print('my_token'+token);
    var body =json.encode({"content_type": content_type, "content_id": content_id,"like_status": likeStatus});
    MainRepository repository=new MainRepository();
    return repository.fetchSaveLikeStatus(body,token);

  }
  Future<AddToCartResponse> addPollAnsersAPI(String NewsId,String answer) async {
    //  final String requestBody = json.encoder.convert(order_items);


    var body =json.encode({"news_id":NewsId,"answer":answer});
    MainRepository repository=new MainRepository();



      return repository.savePollAnswers(body,user_Token);


  }

  Widget _buildPollList(BuildContext context,String newsId,List<Answers> answers) {

    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      itemCount: answers.length , // Add one more item for progress indicator
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        /* if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {*/
        return GestureDetector(
            onTap: () =>
            {


            },
            child:  Container(

                margin:  EdgeInsets.fromLTRB(0,10,0,0),
                child:Stack(

                children:<Widget>[

                  LinearPercentIndicator(
                    leading: new Text(""),
                    trailing: new Text(""),
                    lineHeight: 50.0,
                    linearStrokeCap: LinearStrokeCap.butt,
                    percent: 0.5,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.lightGreen,
                  ),

                  RadioListTile(
                    value: index+1,
                    groupValue: selectedRadioTile,
                    title: Text(answers[index].url),

                    onChanged: (val) {
                      print("Radio Tile pressed $val");
                      setSelectedRadioTile(val);
                      print(answers[index].url);

                     // List answerList = new List();
                     // answerList.add(answers[index].id);

                     addPollAnsersAPI(newsId,answers[index].id.toString());

                    },
                    activeColor: Colors.black,
                    secondary:  Text("55%"),

                    selected: false,
                  )])),);



      }
      // }
      ,

    );
  }

  Widget _buildBoxPoll(BuildContext context,NewsData newsData){


    String user = "king@mail.com";

    //Users who voted Map data
    Map usersWhoVoted = {'sam@mail.com': 3, 'mike@mail.com' : 4, 'john@mail.com' : 1, 'kenny@mail.com' : 1};

    //Creator of the polls email
    String creator = "eddy@mail.com";

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text(newsData.title,style:  GoogleFonts.roboto(
              fontSize: 20,fontWeight:FontWeight.w500),)),
          Padding(

              padding: const EdgeInsets.all(8.0),
              child:SizedBox(
                  height: 450,
                  child:_buildPollList(context,newsData.id.toString(), newsData.answers)
              )
          )
        ]);
  }

}


class MultipleImagesPage extends StatefulWidget {
  NewsData newsData;
  List<EmbedUrls> embedUrls;
  MultipleImagesPage({Key key, this.newsData,this.embedUrls}) : super(key: key);

  @override
  _MultipleImagesPageState createState() => _MultipleImagesPageState(newsData,embedUrls);
}

class _MultipleImagesPageState extends State<MultipleImagesPage> {
  NewsData newsData;
  List<EmbedUrls> embedUrls;
  int mposition=0;

  _MultipleImagesPageState(NewsData mnewsData,List<EmbedUrls> membedUrls){
    newsData=mnewsData;
    embedUrls=membedUrls;
  }


  @override
  Widget build(BuildContext context) {


    PageController controller1=PageController();

    var newsArr=newsData.createdAt.split(" ");
    return Scaffold(

      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Stack(
                children: <Widget>[
                  Container(
                      height:  MediaQuery.of(context).size.height*0.30,
                      color: Colors.black,
                      child:
                      PageView.builder(
                        controller: controller1,
                        scrollDirection: Axis.horizontal,
                        itemCount:embedUrls.length,
                        onPageChanged: (int position) {
                          setState(() {
                            mposition=position;
                          });



                        },
                        itemBuilder: (BuildContext context, int position)
                        {
                          print("my_pos"+position.toString());


                          return
                            Container(
                              margin: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),

                              alignment: Alignment.center,

                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(embedUrls[position].url),

                                  alignment: Alignment.center,
                                ),

                              ),

                            );



                        },


                      )),
                  Positioned.fill(
                      child:Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10,3,10,5),
                              margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                              color:  Color(0xFF5a5a5a),
                              child: Text((mposition+1).toString()+"/"+embedUrls.length.toString(),  style: GoogleFonts.roboto(
                                fontSize:14.0,

                                color: Colors.white,
                                fontWeight: FontWeight.w500,

                              ),))


                      )),
                ]),
            Padding(
                padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text(newsData.title,style:  GoogleFonts.poppins(
                fontSize: 18,fontWeight:FontWeight.w500),)),
            Divider(
              color: Colors.black,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text(newsData.description,style:  GoogleFonts.roboto(
                fontSize: 16,fontWeight:FontWeight.w500),)),

            Row(
                children:<Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text(newsArr[0],style:  GoogleFonts.poppins(
                      fontSize: 16,fontWeight:FontWeight.w500),)),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text("Read More >",style:  GoogleFonts.poppins(color: Colors.orange,
                      fontSize: 16,fontWeight:FontWeight.w500),)),


                ]

            ),

          ]
      )
    );
  }
}


Widget _buildBoxTweet(BuildContext context,List<EmbedUrls> embedUrls){

  String  sampleTweet ="""${embedUrls[0].url}""";
/*  String  sampleTweet = """
<blockquote class="twitter-tweet"><p lang="hi" dir="ltr">हमें कोरोना की इस उभरती हुई &quot;सेकंड पीक&quot; को तुरंत रोकना होगा।<br><br>इसके लिए हमें Quick और Decisive कदम उठाने होंगे: PM <a href="https://twitter.com/narendramodi?ref_src=twsrc%5Etfw">@narendramodi</a></p>&mdash; PMO India (@PMOIndia) <a href="https://twitter.com/PMOIndia/status/1372104052746559489?ref_src=twsrc%5Etfw">March 17, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
  """;*/

 /* String  sampleTweet = """
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Here’s an edit I did of one of my drawings. I tend to draw a lot of aot stuff when each chapter is released. Sorry about that!<br>Song: polnalyubvi кометы<br>Character: Annie Leonhart <a href="https://twitter.com/hashtag/annieleonhart?src=hash&amp;ref_src=twsrc%5Etfw">#annieleonhart</a> <a href="https://twitter.com/hashtag/aot131spoilers?src=hash&amp;ref_src=twsrc%5Etfw">#aot131spoilers</a> <a href="https://twitter.com/hashtag/aot?src=hash&amp;ref_src=twsrc%5Etfw">#aot</a> <a href="https://twitter.com/hashtag/AttackOnTitan131?src=hash&amp;ref_src=twsrc%5Etfw">#AttackOnTitan131</a> <a href="https://twitter.com/hashtag/AttackOnTitans?src=hash&amp;ref_src=twsrc%5Etfw">#AttackOnTitans</a> <a href="https://twitter.com/hashtag/snk?src=hash&amp;ref_src=twsrc%5Etfw">#snk</a> <a href="https://twitter.com/hashtag/snk131?src=hash&amp;ref_src=twsrc%5Etfw">#snk131</a> <a href="https://twitter.com/hashtag/shingekinokyojin?src=hash&amp;ref_src=twsrc%5Etfw">#shingekinokyojin</a> <a href="https://t.co/b4z48ruCoD">pic.twitter.com/b4z48ruCoD</a></p>&mdash; evie (@hazbin_freak22) <a href="https://twitter.com/hazbin_freak22/status/1291884358870142976?ref_src=twsrc%5Etfw">August 7, 2020</a></blockquote>
  """;*/

  var html='<a class="twitter-timeline" href="https://twitter.com/Interior?ref_src=twsrc%5Etfw">Tweets by Interior</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>';

  var newhtml = '''
           <iframe src='${html}></iframe>

     ''';
  return Container(
      padding: EdgeInsets.fromLTRB(10,0,10,0),
      child:
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          SocialEmbed(
              socialMediaObj:
              TwitterEmbedData(embedHtml: sampleTweet)),
    /* HtmlWidget(

            sampleTweet,
            webView: true,
            enableCaching: false,
            customWidgetBuilder: (e) {
              if (e.localName == 'amp-img')
                return HtmlHelper.instance.createImage(e.attributes["src"]);
              else if (e.localName == 'blockquote' && e.attributes['class'] == 'twitter-tweet')
                return HtmlHelper.instance.createTweetWidget(e.innerHtml);
              return null;
            },
          )*/
        ]
    ));

}
Widget _buildBoxVideo(BuildContext context,NewsData newsData,List<EmbedUrls> embedUrls){
 // String url='https://www.youtube.com/watch?v=wY6UyatwVTA';
  var newsArr=newsData.createdAt.split(" ");
  String url=embedUrls[0].url;
  String html;

  if(url.contains('youtube')) {
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
    html = '''
          <iframe id="ytplayer" style="border-left: 0px solid black;border-right: 0px solid black;" type="text/html" width="100%" height="100%"
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=1&enablejsapi=1"
  frameborder="1" allow="autoplay; encrypted-media" allowfullscreen></iframe>
     ''';

  }

  return
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Container(
              height:  MediaQuery.of(context).size.height*0.30,
              color: Colors.black,
              child:  HtmlWidget(

                html,
                webView: true,
              )
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text(newsData.title,style:  GoogleFonts.poppins(
              fontSize: 18,fontWeight:FontWeight.w500),)),
          Divider(
            color: Colors.black,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text(newsData.description,style:  GoogleFonts.roboto(
              fontSize: 16,fontWeight:FontWeight.w500),)),

          Row(
              children:<Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text(newsArr[0],style:  GoogleFonts.poppins(
                    fontSize: 16,fontWeight:FontWeight.w500),)),
                Spacer(),
                Padding(
                    padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text("Read More >",style:  GoogleFonts.poppins(color: Colors.orange,
                    fontSize: 16,fontWeight:FontWeight.w500),)),


              ]

          ),

        ]
    );


}
Widget _buildBoxPotraitVideo(BuildContext context){

}
Widget _buildBoxPotraitImage(BuildContext context,List<EmbedUrls> embedUrls){
  return Container(
      padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      child:
      Container(


        alignment: Alignment.center,

        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: new AssetImage("assets/dummy5.jpg"),

            alignment: Alignment.center,
          ),

        ),

      ));
}

class Pages extends StatelessWidget {
  final text;
  Pages({this.text});
  @override
  Widget build(BuildContext context) {
    PageController controller1=PageController();

    String  sampleTweet = """
<blockquote class="twitter-tweet"><p lang="hi" dir="ltr">हमें कोरोना की इस उभरती हुई &quot;सेकंड पीक&quot; को तुरंत रोकना होगा।<br><br>इसके लिए हमें Quick और Decisive कदम उठाने होंगे: PM <a href="https://twitter.com/narendramodi?ref_src=twsrc%5Etfw">@narendramodi</a></p>&mdash; PMO India (@PMOIndia) <a href="https://twitter.com/PMOIndia/status/1372104052746559489?ref_src=twsrc%5Etfw">March 17, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
  """;

    var html='<a class="twitter-timeline" href="https://twitter.com/Interior?ref_src=twsrc%5Etfw">Tweets by Interior</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>';

    var newhtml = '''
           <iframe src='${html}></iframe>

     ''';
    return
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Container(
                height:  MediaQuery.of(context).size.height*0.30,
                color: Colors.black,
                child:
                PageView(
                  controller: controller1,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),
                        child:Container(


                          alignment: Alignment.center,

                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/dummy1.jpg"),

                              alignment: Alignment.center,
                            ),

                          ),

                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),
                        child:
                        Container(


                          alignment: Alignment.center,

                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/dummy2.jpg"),

                              alignment: Alignment.center,
                            ),

                          ),

                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),
                        child:
                        Container(


                          alignment: Alignment.center,

                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/dummy3.jpeg"),

                              alignment: Alignment.center,
                            ),

                          ),

                        )),

                  ],
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text("भारत ने इंग्लैंड के खिलाफ 3-1 से 4 मैचों की सीरीज जीती",style:  GoogleFonts.poppins(
                fontSize: 18,fontWeight:FontWeight.w500),)),
            Divider(
              color: Colors.black,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text("India topple in ICC Test rankings: भारत ने इंग्लैंड के खिलाफ 4 मैचों की सीरीज को 3-1 से जीता। उसके बाद जारी ताजा आईसीसी रैंकिंग में वह दुनिया के नंबर वन टेस्ट टीम बन गई है। उसने न्यूजीलैंड को पीछे छोड़ा है।",style:  GoogleFonts.roboto(
                fontSize: 16,fontWeight:FontWeight.w500),)),

            Row(
                children:<Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text("13-05-2021",style:  GoogleFonts.poppins(
                      fontSize: 16,fontWeight:FontWeight.w500),)),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(15,20,15,0),child: Text("Read More >",style:  GoogleFonts.poppins(color: Colors.orange,
                      fontSize: 16,fontWeight:FontWeight.w500),)),


                ]

            ),
            HtmlWidget(

              sampleTweet,
              webView: true,
              customWidgetBuilder: (e) {
                if (e.localName == 'amp-img')
                  return HtmlHelper.instance.createImage(e.attributes["src"]);
                else if (e.localName == 'blockquote' && e.attributes['class'] == 'twitter-tweet')
                  return HtmlHelper.instance.createTweetWidget(e.innerHtml);
                return null;
              },
            )
          ]
      );

  }
}