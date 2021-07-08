import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class NewsPage extends StatefulWidget {
  @override
  NewsPageState createState() {
    return NewsPageState();
  }
}

class NewsPageState extends State<NewsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(child:Text('News Page')),

    );
  }


}