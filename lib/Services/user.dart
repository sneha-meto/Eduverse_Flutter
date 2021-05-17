import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static String userNameKey = "USERNAMEKEY";
  static String userRoleKey = "USERROLEKEY";

  static Future<bool> saveName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNameKey, userName);
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<bool> saveRole(String userRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userRoleKey, userRole);
  }

  static Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userRoleKey);
  }
}
