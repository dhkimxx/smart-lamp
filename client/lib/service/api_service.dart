import 'dart:convert';

import 'package:client/models/unit_model.dart';
import 'package:client/service/prefs_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<UnitModel>> getUnitModelList() async {
  final userInfo = await getUserPrefs();
  userInfo['unitList'] = [];

  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(
    Uri.parse('$baseUrl/api/authenticate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(userInfo),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseUserInfo =
        jsonDecode(utf8.decode(response.bodyBytes));
    List<UnitModel> unitModelList = [];
    for (var responseUnitInfo in responseUserInfo['unitList']) {
      responseUnitInfo['user'] = userInfo;
      UnitModel unitModel = UnitModel.fromJsonMap(responseUnitInfo);
      unitModelList.add(unitModel);
    }
    return unitModelList;
  } else {
    print("Failed to get UnitModelList ${response.statusCode}");
    throw Exception('Failed to get UnitModelList ${response.statusCode}');
  }
}

Future<void> postUnitInfo(UnitModel unit) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(Uri.parse('$baseUrl/api/unit'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: unit.toJson() //unit.toJson(),
      );

  if (response.statusCode == 201) {
    print("Succeeded to post unit ${response.statusCode}");
  } else {
    print("Failed to post unit ${response.statusCode}");
    throw Exception('Failed to post unit ${response.statusCode}');
  }
}

Future<void> putUnitInfo(UnitModel unit) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.put(Uri.parse('$baseUrl/api/unit'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: unit.toJson() //unit.toJson(),
      );

  if (response.statusCode == 201) {
    print("Succeeded to put unit ${response.statusCode}");
  } else {
    print("Failed to post unit ${response.statusCode}");
    throw Exception('Failed to put unit ${response.statusCode}');
  }
}

Future<void> deleteUnitInfo(UnitModel unit) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.delete(
    Uri.parse('$baseUrl/api/unit'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: unit.toJson(),
  );

  if (response.statusCode == 200) {
    print("Succeeded to delete unit ${response.statusCode}");
  } else {
    print("Failed to delete unit ${response.statusCode}");
    throw Exception('Failed to delete unit ${response.statusCode}');
  }
}
