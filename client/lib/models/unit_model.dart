class UnitModel {
  final String name;
  final int distance;
  final int time;
  UnitModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        distance = json['distance'],
        time = json['time'];
}
