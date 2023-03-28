import 'package:flutter/material.dart';
import 'package:client/MQTT/my_mqtt_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool ledOn = false;

  void onTapped() {
    if (ledOn) {
      pubMessage("order/unit-1", "LED_OFF");
      ledOn = false;
    } else {
      pubMessage("order/unit-1", "LED_ON");
      ledOn = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 78, 3, 91),
          title: const Text(
            "Smart Lamp",
            style: TextStyle(
              color: Color.fromARGB(255, 196, 164, 6),
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: onTapped,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 212, 127, 213),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(100),
                      child: Text(
                        ledOn ? "OFF" : "ON",
                        style: TextStyle(
                          color: ledOn ? Colors.black : Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
