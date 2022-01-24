import 'package:shared_preferences/shared_preferences.dart';
class HelperFunctions{
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserIdKey = "USERIDKEY";
  static String userDisplayNameKey = "USERDISPLAYKEY";
  static String userProfileKey = "USERPROFILEKEY";


  static Future<bool> saveuserLoggedInSharedPreference(bool isUserLoggedIn)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveuserNameSharedPreference(String userName)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveuserEmailSharedPreference(String userEmail)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveuserIdSharedPreference(String userId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserIdKey, userId);
  }

  static Future<bool> saveuserDisplaySharedPreference(String userDisplay)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userDisplayNameKey, userDisplay);
  }

  static Future<bool> saveuserProfileSharedPreference(String userProfile)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userProfileKey, userProfile);
  }




  static Future<bool> getuserLoggedInSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getuserNameSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getuserEmailSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getuserIdSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserIdKey);
  }

  static Future<String> getuserDisplaySharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(userDisplayNameKey);
  }

  static Future<String> getuserProfileSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(userProfileKey);
  }
}