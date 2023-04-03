import 'package:client/widgets/add_unit_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool unitExist = false;
  bool ledOn = false;
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final units = prefs.getStringList("unitCodes");
    if (units != null) {
      unitExist = true;
    } else {
      prefs.setStringList("unitCodes", []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 5,
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          title: const Text(
            "Smart Lamp",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              AddUnitWidget(),
            ],
          ),
        ));
  }
}
