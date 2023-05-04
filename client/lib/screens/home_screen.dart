import 'package:client/button/add_unit_button.dart';
import 'package:client/models/unit_model.dart';
import 'package:client/screens/add_unit_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/unit_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> userInfo = {};
  late String userName = "";
  List<UnitModel> unitModelList = [];

  Future initPrefs() async {
    userInfo = await getUserInfoPrefs();
    userName = userInfo["userName"].toString();
    unitModelList = await getUnitModelListPrefs();
    setState(() {});
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
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
        title: Text(
          "$userName's Smart Lamps",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.blue,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.replay_circle_filled_sharp),
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              _navigateToLoginScreen();
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
            for (var unit in unitModelList)
              Unit(
                unit: unit,
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
