import 'package:client/models/unit_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<String> putUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userInfo = prefs.getString("userInfo");
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.put(
    Uri.parse('$baseUrl/api/users'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: userInfo,
  );
  if (response.statusCode == 201) {
    print("Succeed to put user ${response.statusCode}");
    return response.body;
  } else {
    throw Exception('Failed to put user ${response.statusCode}');
  }
}

Future<String> postUnitInfo(UnitModel unit) async {
  final unitInfo = unit.toJson();
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.put(
    Uri.parse('$baseUrl/api/units'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: unitInfo,
  );

  if (response.statusCode == 201) {
    print("Succeeded to put unit ${response.statusCode}");
    return response.body;
  } else {
    throw Exception('Failed to put unit ${response.statusCode}');
  }
}
