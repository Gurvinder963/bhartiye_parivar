import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'OnlineBooks.dart';
import 'TrackOrder.dart';

import '../Utils/AppColors.dart';


class MyBooksTabPage extends StatefulWidget {
  @override
  MyBooksTabPageState createState() {
    return MyBooksTabPageState();
  }
}

class MyBooksTabPageState extends State<MyBooksTabPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  TabBar get _tabBar => TabBar(

    unselectedLabelColor: Color(0xFFa0a0a0),
    labelColor: Colors.black,
    labelPadding: EdgeInsets.symmetric (horizontal: 5),
    indicatorWeight: 2,
    indicatorColor: Colors.orange,
    tabs: [
      Tab(child: Text('Online Books')),

      Tab(child: Container(

          width: double.infinity,
  child:
          Row(

            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('|'),
          Expanded(
              child:
                Align(
                  alignment: Alignment.center,
                  child:  Text('Track Order'),
                ))

])

          )),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(AppColors.BaseColor),
          title: Text("My Books"),
        ),
        body:SafeArea(
          top: true,


          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(AppColors.BaseColor),
                toolbarHeight: 50,
                bottom: PreferredSize(
                  preferredSize: _tabBar.preferredSize,
                  child: ColoredBox(
                    color: Color(0xFFe4e4e4),
                    child: _tabBar,
                  ),
                ),
              ),
              body: TabBarView(
                children: [

                  new OnlineBooksPage(),

                  new TrackOrderPage(),

                  //  new SettingsScreen(),
                ],
              ),
            ),
          ),

        )

    );
  }


}