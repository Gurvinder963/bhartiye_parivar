import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static const String KEY_TOKEN = 'TOKEN';
  static const String USER_NAME = 'USER_NAME';
  static const String USER_ID = 'USER_ID';


  /*1 = Applicant
  * 2= Officer
  * 3 = Admin
  * 4= Tp Validator*/

  static setUserLoginId(SharedPreferences prefs, String userId) async {

    return prefs.setString(USER_ID, userId);
  }
  static setUserLoginToken(SharedPreferences prefs, String Token) async {

    return prefs.setString(KEY_TOKEN, Token);
  }
  static setUserLoginName(SharedPreferences prefs, String Name) async {

    return prefs.setString(USER_NAME, Name);
  }
}