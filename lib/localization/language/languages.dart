import 'package:flutter/material.dart';

abstract class Languages {

  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }


  String get langCode;

  String get appName;
  String get aboutUs;
  String get joinUs;
  String get donateUs;
  String get contactUs;
  String get profile;
  String get appLanguage;
  String get contentLanguage;
  String get notifications;
  String get darkMode;
  String get faq;
  String get shareApp;
  String get termsndPrivacy;
  String get main;
  String get Trending;
  String get Health;
  String get Series;
  String get Spiritual;
  String get History;
  String get Culture;
  String get Conspiracy;
  String get Twitter;
  String get Facebook;
  String get Instagram;
  String get Telegram;
  String get Whatsapp;
  String get Home;
  String get News;
  String get Books;

  String get labelWelcome;

  String get labelInfo;

  String get labelSelectLanguage;
  String get logout;

}
