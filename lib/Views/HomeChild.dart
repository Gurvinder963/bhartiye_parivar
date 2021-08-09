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
import '../localization/language/languages.dart';

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
             // shape: Border(bottom: BorderSide(color:Color(0xFF5a5a5a))),
              leading: new Container(),
              backgroundColor: Color(AppColors.BaseColor),
              toolbarHeight: 40,
              flexibleSpace: TabBar(
                isScrollable: true,
                unselectedLabelColor: Color(0xFF5a5a5a),
                labelColor: Colors.white,
                indicatorWeight: 3,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child: Text(Languages
                      .of(context)
                      .main,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Trending,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Health,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Series,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Spiritual,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .History,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Culture,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Conspiracy,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Twitter,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Facebook,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Instagram,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Telegram,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .Whatsapp,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
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