import 'dart:convert';

class UnitModel {
  final String unitCode;
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
      : unitCode = json['unitCode'].toString(),
        unitName = json['unitName'].toString(),
        distance = json['distance'],
        time = json['time'];

  String toJson() {
    Map<String, dynamic> unitInfoJson = {
      'unitCode': unitCode,
      'unitName': unitName,
      'distance': distance,
      'time': time,
    };
    return jsonEncode(unitInfoJson);
  }
}
