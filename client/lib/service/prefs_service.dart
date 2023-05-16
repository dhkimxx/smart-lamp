import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// isLogined
Future<bool> getIsLoginedPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final isLogined = prefs.getBool("isLogined");
  if (isLogined == null) {
    return false;
  } else {
    return isLogined;
  }
}

Future<void> setIsLoginedPrefs(bool isLogined) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLogined", isLogined);
}

// user
Future<Map<String, dynamic>> getUserPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userInfo = prefs.getString("userInfo");
  if (userInfo == null) {
    return {};
  } else {
    return jsonDecode(userInfo);
  }
}

Future<void> setUserInfoPrefs(String userInfo) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> userInfoMap = jsonDecode(userInfo);
  userInfoMap['unitList'] = [];
  userInfo = jsonEncode(userInfoMap);
  await prefs.setString("userInfo", userInfo);
}
