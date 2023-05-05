import 'dart:convert';

import 'package:client/models/unit_model.dart';
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
  await prefs.setString("userInfo", userInfo);
}

// unit
Future<void> setUnitInfoPrefs(String unitCode, String unitInfo) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(unitCode, unitInfo);
}

Future<UnitModel> getUnitPrefs(String unitCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return UnitModel.fromJsonMap(
      jsonDecode(prefs.getString(unitCode).toString()));
}

// unitList
Future<List<String>> getUnitListPrefs() async {
  final userInfo = await getUserPrefs();
  if (userInfo['unitList'] == null) {
    return <String>[];
  } else {
    List<String> unitList = List<String>.from(userInfo['unitList']);
    return unitList;
  }
}

// unitModelList
Future<List<UnitModel>> getUnitModelListPrefs() async {
  List<UnitModel> unitModelList = [];
  List<String> unitList = await getUnitListPrefs();
  for (var unitCode in unitList) {
    UnitModel unit = await getUnitPrefs(unitCode);
    unitModelList.add(unit);
  }
  return unitModelList;
}
