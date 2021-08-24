import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Views/html_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:polls/polls.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'NewsMain.dart';
class NewsPage extends StatefulWidget {
  @override
  NewsPageState createState() {
    return NewsPageState();
  }
}

class NewsPageState extends State<NewsPage> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {

// Here you can write your code

      Navigator.of(context, rootNavigator: true)
          .push( // ensures fullscreen
          MaterialPageRoute(
              builder: (BuildContext context) {
                return NewsMainPage();
              }
          ));
    });

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,);
  }




}


