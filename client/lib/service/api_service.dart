import 'dart:convert';

import 'package:client/models/unit_model.dart';
import 'package:client/service/prefs_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> joinUser(String userId, String userPw, String userName) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(
    Uri.parse('$baseUrl/api/user'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': userId,
      'userPw': userPw,
      'userName': userName,
    }),
  );

  if (response.statusCode == 201) {
    print("join success ${response.statusCode}");
  } else {
    print("Failed to join ${response.statusCode}");
    throw Exception('Failed to join user ${response.statusCode}');
  }
}

Future<String> loginUser(String userId, String userPw) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(
    Uri.parse('$baseUrl/api/user/authenticate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': userId,
      'userPw': userPw,
    }),
  );

  if (response.statusCode == 200) {
    print("login success ${response.statusCode}");
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception('Failed to login user ${response.statusCode}');
  }
}

Future<void> logoutUser() async {
  final userInfo = await getUserPrefs();
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.patch(
    Uri.parse('$baseUrl/api/user/authenticate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(userInfo),
  );
  if (response.statusCode == 200) {
    print("logout success ${response.statusCode}");
  } else {
    throw Exception('Failed to logout user ${response.statusCode}');
  }
}

Future<List<UnitModel>> getUnitModelList() async {
  final userInfo = await getUserPrefs();

  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(
    Uri.parse('$baseUrl/api/unit/unitList'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(userInfo),
  );

  if (response.statusCode == 200) {
    List responseUserInfo = jsonDecode(utf8.decode(response.bodyBytes));
    List<UnitModel> unitModelList = [];
    for (var responseUnitInfo in responseUserInfo) {
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
  final response = await http.post(
    Uri.parse('$baseUrl/api/unit'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: unit.toJson(),
  );

  if (response.statusCode == 201) {
    print("Succeeded to post unit ${response.statusCode}");
  } else {
    print("Failed to post unit ${response.statusCode}");
    throw Exception('Failed to post unit ${response.statusCode}');
  }
}

Future<void> patchUnitInfo(UnitModel unit) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.patch(Uri.parse('$baseUrl/api/unit'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: unit.toJson());

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

  if (response.statusCode == 204) {
    print("Succeeded to delete unit ${response.statusCode}");
  } else {
    print("Failed to delete unit ${response.statusCode}");
    throw Exception('Failed to delete unit ${response.statusCode}');
  }
}
