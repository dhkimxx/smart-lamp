import 'package:client/MQTT/mqtt_client.dart';
import 'package:flutter/material.dart';

class UnitDetailScreen extends StatelessWidget {
  final String unitCode;
  final String unitName;
  UnitDetailScreen({
    super.key,
    required this.unitCode,
    required this.unitName,
  });
  var myMqttClient = MyMqttClient();

  var distance = 50;

  @override
  Widget build(BuildContext context) {
    myMqttClient.connect();
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: Text(
          unitName,
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
                          unitCode,
                          'ON',
                        );
                      },
                      child: const Text('ON'),
                    ),
                    TextButton(
                      onPressed: () {
                        myMqttClient.pubMessage(
                          unitCode,
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
                  autofocus: false,
                  initialValue: '$distance',
                  textAlign: TextAlign.center,
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
          )
        ],
      ),
    );
  }
}
