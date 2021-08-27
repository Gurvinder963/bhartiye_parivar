import 'dart:convert';

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
  int _curr=0;

  Future<AddToCartResponse> postAddBookMark(String content_type,String token,String content_id) async {
    String status = "0";
    if (isBookMarked) {
      status = "0";

    } else {

      status = "1";
    }
    print('my_token'+token);
    var body =json.encode({"content_type": content_type, "content_id": content_id,"keyStatus": status});
    MainRepository repository=new MainRepository();
    return repository.fetchAddBookMark(body,token);

  }

  Future<NewsResponse> getNewsList(String user_Token) async {

    var body ={'lang_code':''};
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
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}

      getNewsList(user_Token).then((value) => {

        setState(() {
          isLoading = false;
          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
      print('Backbutton pressed (device or appbar button), do whatever you want.');
      print("On bottom back clicked");

      //trigger leaving and use own data
      Navigator.pop(context, false);


      eventBus1.fire(OnNewsBack("FIND"));
      //we need to return a future
      return Future.value(false);
    },
    child:Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text('News', style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),
        actions: <Widget>[

          IconButton(
              icon: isBookMarked? Image(
                image: new AssetImage("assets/bookmark_sel.png"),
                width: 24,
                height:  24,
                color: null,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ): Image(
                image: new AssetImage("assets/bookmark_unsel.png"),
                width: 24,
                height:  24,
                color: null,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ),
              onPressed: () {
                setState(() {
                  _isInAsyncCall = true;
                });

                postAddBookMark("2",user_Token,mainData[mPagePosition].id.toString())
                    .then((res) async {
                  setState(() {
                    _isInAsyncCall = false;
                  });


                  if (res.status == 1) {


                    Fluttertoast.showToast(
                        msg: "Bookmark added!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);


                  }
                  else {
                    // showAlertDialogValidation(context,"Some error occured!");
                  }
                });

                //  submitFavourite("1",tok,MyContentId.toString(),false);
              }),

          SizedBox(
            width: 20,
          ),

        ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
              print("On tap back clicked"),
            eventBus1.fire(OnNewsBack("FIND")),
              Navigator.of(context).pop()},
          )
      ),
      body:  ModalProgressHUD(
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.01,
    progressIndicator: CircularProgressIndicator(),
    child:Column (

          children: [
            Container(
                height: MediaQuery.of(context).size.height*0.80 ,
                child:new PreloadPageView.builder(
                  scrollDirection: Axis.vertical,
                    itemCount:mainData.length+1,
                    itemBuilder: (BuildContext context, int position)
                        {
                        if (position == mainData.length) {
                        return _buildProgressIndicator();
                        } else {
                          print("my_pos"+position.toString());
                          Widget wid;
                          if(mainData[position].newsType==1){
                            wid=
                                _buildBoxMultipleImagesList(context,mainData[position],mainData[position].embedUrls);
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


                          return wid;
                        }},
                    onPageChanged: (int position) {

                      mPagePosition=position;

                    },

                    preloadPagesCount: 3,
                    controller: PreloadPageController(),
    )
     /*       PageView(

        physics: const CustomPageViewScrollPhysics(),
        children: <Widget>[

          _buildBoxMultipleImagesList(context),
          _buildBoxVideo(context),
          _buildBoxTweet(context),
          _buildBoxPotraitImage(context),
          _buildBoxPoll(context)
        ],
        scrollDirection: Axis.vertical,

        // reverse: true,
        // physics: BouncingScrollPhysics(),
        controller: controller,
        onPageChanged: (num){
          setState(() {
            _curr=num;
          });
        },
      )*/),
       SizedBox(
              height: MediaQuery.of(context).size.height*0.09 ,
              child:Column ( children: <Widget>[
            Divider(
            height: 0.5,
            thickness: 0.6,
            color: Colors.black,
          ),
            Container(
              margin:  EdgeInsets.fromLTRB(20,15,10,10),
              child:Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 5,),
                    Image(
                      image: new AssetImage("assets/like_unsel.png"),
                      width: 24,
                      height:  24,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
                    SizedBox(width: 17,),
                    Image(
                      image: new AssetImage("assets/dislike_unsel.png"),
                      width: 24,
                      height:  24,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
                    SizedBox(width: 17,),
                    Icon(Icons.report_outlined,size: 28,color:Colors.black,),
                    SizedBox(width: 17,),
                    Image(
                      image: new AssetImage("assets/share.png"),
                      width: 23,
                      height:  23,
                      color:Colors.black,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
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

    ));
  }
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }
  Widget _buildBoxPoll(BuildContext context){


    String user = "king@mail.com";

    //Users who voted Map data
    Map usersWhoVoted = {'sam@mail.com': 3, 'mike@mail.com' : 4, 'john@mail.com' : 1, 'kenny@mail.com' : 1};

    //Creator of the polls email
    String creator = "eddy@mail.com";

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(15,10,15,0),child: Text("Bharat kya match jeet paega Bharat kya match jeet paega paega Bharat kya match jeet paega ?",style:  GoogleFonts.roboto(
              fontSize: 16,fontWeight:FontWeight.w500),)),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child:SizedBox(
                  height: 450,
                  child:ListView(

                      children:<Widget>[

                        Stack(
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
                                value: 1,
                                groupValue: selectedRadioTile,
                                title: Text("Yes"),

                                onChanged: (val) {
                                  print("Radio Tile pressed $val");
                                  setSelectedRadioTile(val);
                                },
                                activeColor: Colors.black,
                                secondary:  Text("55%"),

                                selected: true,
                              )]),
                        RadioListTile(
                          value: 2,
                          groupValue: selectedRadioTile,
                          title: Text("No"),

                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                          activeColor: Colors.black,
                          secondary: Text("45%"),


                          selected: false,
                        ),
                        RadioListTile(
                          value: 2,
                          groupValue: selectedRadioTile,
                          title: Text("May be"),

                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                          activeColor: Colors.black,
                          secondary: Text("35%"),


                          selected: false,
                        ),
                      ])))]);
  }

}

Widget _buildBoxMultipleImagesList(BuildContext context,NewsData newsData,List<EmbedUrls> embedUrls){
  PageController controller1=PageController();

   var newsArr=newsData.createdAt.split(" ");

  return
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Container(
              height:  MediaQuery.of(context).size.height*0.30,
              color: Colors.black,
              child:
              PageView.builder(
                controller: controller1,
                scrollDirection: Axis.horizontal,
                itemCount:embedUrls.length,
                itemBuilder: (BuildContext context, int position)
                {
                  print("my_pos"+position.toString());


                  return Stack(
                      children: <Widget>[
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

                      ),
                        Positioned.fill(
                            child:Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(10,3,10,5),
                                    margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                                    color:  Color(0xFF5a5a5a),
                                    child: Text((position+1).toString()+"/"+embedUrls.length.toString(),  style: GoogleFonts.roboto(
                                      fontSize:14.0,

                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,

                                    ),))


                            )),

                      ]);
                },


              )),
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