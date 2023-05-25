import 'dart:convert';

class UnitModel {
  final String unitCode;
  final String unitName;
  final int distance;
  final int time;
  final int brightness;
  final Map<String, dynamic> user;

  UnitModel({
    required this.unitCode,
    required this.unitName,
    required this.distance,
    required this.time,
    required this.brightness,
    required this.user,
  });

  UnitModel.fromJsonMap(Map<String, dynamic> json)
      : unitCode = json['unitCode'].toString(),
        unitName = json['unitName'].toString(),
        distance = json['distance'],
        time = json['time'],
        brightness = json['brightness'],
        user = json['user'];

  String toJson() {
    Map<String, dynamic> unitInfoJson = {
      'unitCode': unitCode,
      'unitName': unitName,
      'distance': distance,
      'time': time,
      'brightness': brightness,
      'user': user,
    };
    return jsonEncode(unitInfoJson);
  }
}
