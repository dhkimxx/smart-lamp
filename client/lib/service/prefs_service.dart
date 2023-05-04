import 'dart:convert';

import 'package:client/models/unit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getIsLogined() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final isLogined = prefs.getBool("isLogined");
  if (isLogined == null) {
    return false;
  } else {
    return isLogined;
  }
}

Future<void> setIsLogined(bool isLogined) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLogined", isLogined);
}

Future<Map<String, dynamic>> getUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userInfo = prefs.getString("userInfo");
  if (userInfo == null) {
    return {};
  } else {
    return jsonDecode(userInfo);
  }
}

Future<void> setUserInfo(String userInfo) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userInfo", userInfo);
}

Future<List<String>> getUnitList() async {
  final userInfo = await getUserInfo();
  if (userInfo['unitList'] == null) {
    return <String>[];
  } else {
    List<String> unitList = List<String>.from(userInfo['unitList']);
    return unitList;
  }
}

Future<void> setUnitList(List<String> newUnitList) async {
  final newUserInfo = await getUserInfo();
  print(newUserInfo['unitList']);
  print(newUnitList);
  newUserInfo['unitList'] = newUnitList;
  await setUserInfo(jsonEncode(newUserInfo));
}

Future<List<UnitModel>> getUnitModelList() async {
  List<UnitModel> unitModelList = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> unitList = await getUnitList();
  for (var unitCode in unitList) {
    UnitModel unit = UnitModel.fromJsonMap(
      jsonDecode(prefs.getString(unitCode).toString()),
    );
    unitModelList.add(unit);
  }
  return unitModelList;
}
