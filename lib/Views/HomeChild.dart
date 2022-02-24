import 'dart:convert';

import 'package:bhartiye_parivar/Interfaces/OnHomeTabChange.dart';
import 'package:bhartiye_parivar/Views/LivePage.dart';
import 'package:bhartiye_parivar/Views/SocialMedia.dart';
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
import 'Chat.dart';
import 'Twitter.dart';
import 'History.dart';
import 'Instagram.dart';
import '../Utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../localization/language/languages.dart';
import 'package:bhartiye_parivar/Interfaces/OnHomeTapped.dart';
import 'package:bhartiye_parivar/Interfaces/OnLandScape.dart';

class HomeChildPage extends StatefulWidget {
  const HomeChildPage({Key key}) : super(key: key);
  @override
  HomeChildPageState createState() {
    return HomeChildPageState();
  }
}

class HomeChildPageState extends State<HomeChildPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  bool isFullScreen=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(vsync: this, length: 11)  ..addListener(() {
      if(tabController.indexIsChanging) {
        print("tab is animating. from active (getting the index) to inactive(getting the index) ");
      }else {
        //tab is finished animating you get the current index
        //here you can get your index or run some method once.
        if(tabController.index==0){
          eventBusHTC.fire(OnHomeTabChange("main"));
        }
        else if(tabController.index==1){
          eventBusHTC.fire(OnHomeTabChange("trending"));
        }
        else if(tabController.index==2){
          eventBusHTC.fire(OnHomeTabChange("series"));
        }
        else if(tabController.index==3){
          eventBusHTC.fire(OnHomeTabChange("live"));
        }
        else if(tabController.index==4){
          eventBusHTC.fire(OnHomeTabChange("health"));
        }
        else if(tabController.index==5){
          eventBusHTC.fire(OnHomeTabChange("spiritual"));
        }
        else if(tabController.index==6){
          eventBusHTC.fire(OnHomeTabChange("history"));
        }
        else if(tabController.index==7){
          eventBusHTC.fire(OnHomeTabChange("culture"));
        }
        else if(tabController.index==8){
          eventBusHTC.fire(OnHomeTabChange("conspiracy"));
        }


        print(tabController.index);
      }
    });

    eventBusHT.on<OnHomeTapped>().listen((event) {
      tabController.animateTo(0);
    });

    eventBusLSP.on<OnLandScape>().listen((event) {

      var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;


      if(event.count=='Land' && isPortrait){

        setState(() {
          isFullScreen=true;
        });
      }
      else if(event.count=='Port' && !isPortrait){
        setState(() {
          isFullScreen=false;
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:SafeArea(
      top: true,


        child: DefaultTabController(
          length: 11,
          child: Scaffold(
            appBar: isFullScreen?null:AppBar(
             // shape: Border(bottom: BorderSide(color:Color(0xFF5a5a5a))),
              leading: new Container(),
              backgroundColor: Color(AppColors.BaseColor),
              toolbarHeight: 34,
              flexibleSpace: TabBar(
                controller: tabController,
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
                      .Series,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  Tab(child: Text(Languages
                      .of(context)
                      .LiveTag,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),


                  Tab(child: Text(Languages
                      .of(context)
                      .Health,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),

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
                      .SocialMedia,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  // Tab(child: Text(Languages
                  //     .of(context)
                  //     .Facebook,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  // Tab(child: Text(Languages
                  //     .of(context)
                  //     .Instagram,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  // Tab(child: Text(Languages
                  //     .of(context)
                  //     .Telegram,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                  // Tab(child: Text(Languages
                  //     .of(context)
                  //     .Whatsapp,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),

                  Tab(child: Text(Languages
                      .of(context)
                      .Chat,style:GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w600),)),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [

                new MainPage(),
                new TrendingPage(),

                new SeriesPage(),
                new LivePage(),
                new HealthPage(),
                new SpiritualPage(),
                new HistoryPage(),
                new CulturePage(),
                new ConspiracyPage(),
                new SocialMediaPage(),
                new ChatPage(),
                //  new SettingsScreen(),
              ],
            ),
          ),
        ),

    )

    );
  }


}