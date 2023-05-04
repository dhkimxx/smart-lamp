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

// userInfo
Future<Map<String, dynamic>> getUserInfoPrefs() async {
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

// unitInfo
Future<void> setUnitInfoPrefs(UnitModel unit) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(unit.unitCode, unit.toJson());
}

Future<String> getUnitInfoPrefs(String unitCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(unitCode).toString();
}

// unitList
Future<List<String>> getUnitListPrefs() async {
  final userInfo = await getUserInfoPrefs();
  if (userInfo['unitList'] == null) {
    return <String>[];
  } else {
    List<String> unitList = List<String>.from(userInfo['unitList']);
    return unitList;
  }
}

Future<void> setUnitListPrefs(List<String> newUnitList) async {
  final newUserInfo = await getUserInfoPrefs();
  newUserInfo['unitList'] = newUnitList;
  await setUserInfoPrefs(jsonEncode(newUserInfo));
}

// unitModelList
Future<List<UnitModel>> getUnitModelListPrefs() async {
  List<UnitModel> unitModelList = [];
  List<String> unitList = await getUnitListPrefs();
  for (var unitCode in unitList) {
    final unitInfo = await getUnitInfoPrefs(unitCode);
    UnitModel unit = UnitModel.fromJsonMap(
      jsonDecode(unitInfo),
    );
    unitModelList.add(unit);
  }
  return unitModelList;
}
