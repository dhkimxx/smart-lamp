import 'package:client/button/add_unit_button.dart';
import 'package:client/screens/add_unit_screen.dart';
import 'package:client/widgets/unit_widget.dart';
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
  List<String> unitCodeList = [];
  Map<String, String> unitNameMap = {};

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final unitCodes = prefs.getStringList("unitCodes");
    if (unitCodes != null) {
      unitExist = true;
      unitCodeList = unitCodes;
      for (var unitCode in unitCodes) {
        unitNameMap[unitCode] = prefs.getString(unitCode)!;
      }
    } else {
      prefs.setStringList("unitCodes", []);
    }
    setState(() {});
    print(unitNameMap);
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
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
        leading: const IconButton(
          icon: Icon(Icons.menu),
          onPressed: null,
        ),
        actions: [
          IconButton(
            onPressed: initPrefs,
            icon: const Icon(Icons.replay_circle_filled_sharp),
          ),
          IconButton(
            onPressed: () {
              prefs.clear();
              unitCodeList = [];
              setState(() {});
            },
            icon: const Icon(Icons.new_releases_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            for (var unitCode in unitCodeList)
              Unit(
                unitCode: unitCode,
                unitName: unitNameMap[unitCode]!,
              ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddUnitScreen(),
                    ),
                  ).then((value) {
                    initPrefs();
                  });
                },
                child: const AddUnitButton()),
          ],
        ),
      ),
    );
  }
}
