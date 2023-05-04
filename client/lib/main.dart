import 'package:client/screens/home_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/service/prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isInitialized = false;
  late bool isLogined = false;

  Future initPrefs() async {
    isLogined = await getIsLogined();
    isInitialized = true;
    getUnitList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    if (isInitialized == true) {
      return MaterialApp(
        home: isLogined ? const HomeScreen() : const LoginScreen(),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              width: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/tukorea.jpg"),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
