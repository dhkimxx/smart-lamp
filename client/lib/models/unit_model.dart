class UnitModel {
  dynamic code;
  final String name;
  final int distance;
  final int time;
  UnitModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'],
        distance = json['distance'],
        time = json['time'];
}
