import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class TwitterPage extends StatefulWidget {
  @override
  TwitterPageState createState() {
    return TwitterPageState();
  }
}

class TwitterPageState extends State<TwitterPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(child:Text('Twitter Page')),

    );
  }


}