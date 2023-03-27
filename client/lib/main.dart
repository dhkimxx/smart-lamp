import 'package:flutter/material.dart';
import 'package:client/MQTT/mqtt_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void onTapped() {
    pubMessage("state", "L111");
    print("state.");
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
                      padding: const EdgeInsets.all(30),
                      child: const Text(
                        "unit-1",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
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
