import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Views/html_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:polls/polls.dart';
import 'package:percent_indicator/percent_indicator.dart';
class NewsPage extends StatefulWidget {
  @override
  NewsPageState createState() {
    return NewsPageState();
  }
}

class NewsPageState extends State<NewsPage> {
  PageController controller=PageController();
  int selectedRadio = 0;
  int selectedRadioTile = 0;
  int _curr=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  PageView(
        children: <Widget>[

          _buildBoxMultipleImagesList(context),
          _buildBoxVideo(context),
          _buildBoxTweet(context),
          _buildBoxPotraitImage(context),
          _buildBoxPoll(context)
        ],
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        // reverse: true,
        // physics: BouncingScrollPhysics(),
        controller: controller,
        onPageChanged: (num){
          setState(() {
            _curr=num;
          });
        },
      ),

    );
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

Widget _buildBoxMultipleImagesList(BuildContext context){
  PageController controller1=PageController();


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

        ]
    );

}
Widget _buildBoxTweet(BuildContext context){


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

          HtmlWidget(

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
          )
        ]
    );

}
Widget _buildBoxVideo(BuildContext context){
String url='https://www.youtube.com/watch?v=wY6UyatwVTA';

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

        ]
    );


}
Widget _buildBoxPotraitVideo(BuildContext context){

}
Widget _buildBoxPotraitImage(BuildContext context){
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