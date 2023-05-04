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
    print("put success ${response.statusCode}");
    return response.body;
  } else {
    throw Exception('Failed to put user${response.statusCode}');
  }
}
