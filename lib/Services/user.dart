import 'package:eduverse/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static String userNameKey = "USERNAMEKEY";
  static String userRoleKey = "USERROLEKEY";
  static String userBranchKey = "USERBRANCHKEY";

  static Future<bool> saveName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }

  static Future<bool> saveRole(String userRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userRoleKey, userRole);
  }

  static Future<bool> saveBranch(String userBranch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("new branch:$userBranch");
    return prefs.setString(userBranchKey, userBranch);
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userRoleKey);
  }

  static Future<String> getBranch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userBranchKey);
  }

  static Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.myName = prefs.getString(userNameKey);
    Constants.myRole = prefs.getString(userRoleKey);
    Constants.myBranch = prefs.getString(userBranchKey);
  }
}
