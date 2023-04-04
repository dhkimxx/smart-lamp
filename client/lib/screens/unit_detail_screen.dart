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

  @override
  Widget build(BuildContext context) {
    myMqttClient.connect();
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Row(
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
      ),
    );
  }
}
