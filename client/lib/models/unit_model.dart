import 'dart:convert';

class UnitModel {
  final dynamic unitCode;
  final String unitName;
  final int distance;
  final int time;

  UnitModel({
    required this.unitCode,
    required this.unitName,
    required this.distance,
    required this.time,
  });

  UnitModel.fromJsonMap(Map<String, dynamic> json)
      : unitCode = json['code'],
        unitName = json['name'],
        distance = json['distance'],
        time = json['time'];

  String toJsonString() {
    Map<String, dynamic> unitInfoJson = {};
    unitInfoJson = {
      'code': unitCode,
      'name': unitName,
      'distance': distance,
      'time': time,
    };
    return jsonEncode(unitInfoJson);
  }
}
