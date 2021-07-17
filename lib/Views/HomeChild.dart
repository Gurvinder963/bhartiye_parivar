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
import 'package:google_fonts/google_fonts.dart';


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
              shape: Border(bottom: BorderSide(color:Color(0xFF5a5a5a))),
              leading: new Container(),
              backgroundColor: Color(AppColors.BaseColor),
              toolbarHeight: 30,
              flexibleSpace: TabBar(
                isScrollable: true,
                unselectedLabelColor: Color(0xFF5a5a5a),
                labelColor: Colors.white,
                indicatorWeight: 6,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child: Text('Main' ,style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Trending',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Health',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Series',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Spiritual',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('History',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Culture',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Conspiracy',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Twitter',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Facebook',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Instagram',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Telegram',style:GoogleFonts.roboto(fontSize: 17),)),
                  Tab(child: Text('Whatsapp',style:GoogleFonts.roboto(fontSize: 17),)),
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