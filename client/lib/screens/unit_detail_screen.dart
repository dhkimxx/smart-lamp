import 'dart:convert';
import 'package:client/MQTT/mqtt_client.dart';
import 'package:client/models/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitDetailScreen extends StatefulWidget {
  final UnitModel unit;

  const UnitDetailScreen({
    super.key,
    required this.unit,
  });

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen> {
  int distance = 5000;
  int time = 10000;
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final unit = UnitModel.fromJsonMap(
      jsonDecode(
        prefs.getString(widget.unit.unitCode)!,
      ),
    );
    distance = unit.distance;
    time = unit.time;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    var myMqttClient = MyMqttClient();
    myMqttClient.connect();
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: Text(
          widget.unit.unitName,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blue,
                    )),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        myMqttClient.pubMessage(
                          widget.unit.unitCode,
                          'ON',
                        );
                      },
                      child: const Text('ON'),
                    ),
                    TextButton(
                      onPressed: () {
                        myMqttClient.pubMessage(
                          widget.unit.unitCode,
                          'OFF',
                        );
                      },
                      child: const Text('OFF'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '감지 거리(cm):  ',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 50,
                height: 48,
                child: TextFormField(
                  key: Key('$distance'),
                  autofocus: false,
                  initialValue: '$distance',
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    if (value != '') {
                      distance = int.parse(value);
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue),
                child: TextButton(
                  onPressed: () {
                    print(distance);
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
