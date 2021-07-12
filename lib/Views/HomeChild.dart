import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MainPage.dart';
import 'Spiritual.dart';
import 'Conspiracy.dart';
import 'Facebook.dart';
import 'Telegram.dart';
import 'Whatsapp.dart';
import 'Health.dart';
import 'Trending.dart';
import 'Series.dart';
import 'Culture.dart';
import 'Twitter.dart';
import 'History.dart';
import 'Instagram.dart';
import '../Utils/AppColors.dart';


class HomeChildPage extends StatefulWidget {
  @override
  HomeChildPageState createState() {
    return HomeChildPageState();
  }
}

class HomeChildPageState extends State<HomeChildPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:SafeArea(
      top: true,


        child: DefaultTabController(
          length: 13,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(AppColors.BaseColor),
              toolbarHeight: kMinInteractiveDimension,
              flexibleSpace: TabBar(
                isScrollable: true,
                unselectedLabelColor: Color(0xFF666666),
                labelColor: Colors.white,
                indicatorWeight: 2,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child: Text('Main')),
                  Tab(child: Text('Trending')),
                  Tab(child: Text('Health')),
                  Tab(child: Text('Series')),
                  Tab(child: Text('Spiritual')),
                  Tab(child: Text('History')),
                  Tab(child: Text('Culture')),
                  Tab(child: Text('Conspiracy')),
                  Tab(child: Text('Twitter')),
                  Tab(child: Text('Facebook')),
                  Tab(child: Text('Instagram')),
                  Tab(child: Text('Telegram')),
                  Tab(child: Text('Whatsapp')),
                ],
              ),
            ),
            body: TabBarView(
              children: [

                new MainPage(),
                new TrendingPage(),
                new HealthPage(),
                new SeriesPage(),
                new SpiritualPage(),
                new HistoryPage(),
                new CulturePage(),
                new ConspiracyPage(),
                new TwitterPage(),
                new FacebookPage(),
                new InstagramPage(),
                new TelegramPage(),
                new WhatsappPage(),
                //  new SettingsScreen(),
              ],
            ),
          ),
        ),

    )

    );
  }


}