import 'package:client/MQTT/mqtt_client.dart';
import 'package:flutter/material.dart';

class UnitDetailScreen extends StatelessWidget {
  final String unitCode;
  UnitDetailScreen({super.key, required this.unitCode});
  final myMqttClient = MyMqttClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: Text(unitCode),
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
                      myMqttClient.pubMessage(unitCode, 'ON');
                    },
                    child: const Text('ON'),
                  ),
                  TextButton(
                    onPressed: () {
                      myMqttClient.pubMessage(unitCode, 'OFF');
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
