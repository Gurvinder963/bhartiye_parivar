import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {




  @override
  Widget build(BuildContext context) {
   // var my_url="https://www.facebook.com/ytAndroidTutorials/videos/943691813081351";
   // var my_url="https://www.youtube.com/watch?v=llAhk_KIXfQ";
   /* String html = '''
           <iframe width="200" height='400'
            src="https://www.facebook.com/v2.3/plugins/video.php? 
            allowfullscreen=false&autoplay=true&href=${my_url}" </iframe>
     ''';*/

    var widht=MediaQuery.of(context).size.width;

 /*   String html = '''
          <iframe id="ytplayer" type="text/html" width="640" height="360"
  src="https://www.youtube.com/embed/llAhk_KIXfQ?autoplay=1&origin=http://example.com"
  frameborder="0"></iframe>
     ''';*/

 var my_url="x82qaiq";
       String html = '''
           <iframe src='http://www.dailymotion.com/embed/video/${my_url}?quality=240&info=0&logo=0' allowFullScreen></iframe>

     ''';


    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: new SingleChildScrollView(
          child: HtmlWidget(
            html,
            webView: true,
          ),
        ),

      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}