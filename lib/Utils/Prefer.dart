import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static const String KEY_TOKEN = 'TOKEN';
  static const String USER_NAME = 'USER_NAME';
  static const String USER_ID = 'USER_ID';
  static const String CART_COUNT = 'CART_COUNT';
  static const String DONATION_AMOUNT = 'Donation_Amount';

  static const String USER_MOBILE = 'USER_MOBILE';
  static const String USER_C_CODE = 'USER_C_CODE';
  static const String USER_AGE = 'USER_AGE';
  static const String USER_PROFESSION = 'USER_PROFESSION';
  static const String USER_POSTAL = 'USER_POSTAL';
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
  static setCartCount(SharedPreferences prefs, String count) async {

    return prefs.setString(CART_COUNT, count);
  }
  static setDonationAmount(SharedPreferences prefs, String count) async {

    return prefs.setString(DONATION_AMOUNT, count);
  }

  static setUserAge(SharedPreferences prefs, String Name) async {

    return prefs.setString(USER_AGE, Name);
  }
  static setUserProfession(SharedPreferences prefs, String Name) async {

    return prefs.setString(USER_PROFESSION, Name);
  }
  static setUserPostal(SharedPreferences prefs, String Name) async {

    return prefs.setString(USER_POSTAL, Name);
  }

  static setUserMobile(SharedPreferences prefs, String Name) async {

    return prefs.setString(USER_MOBILE, Name);
  }
  static setUserCCode(SharedPreferences prefs, String Name) async {

    return prefs.setString(USER_C_CODE, Name);
  }


}