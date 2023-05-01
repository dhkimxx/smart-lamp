import 'package:client/screens/home_screen.dart';
import 'package:client/screens/join_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final bool islogined = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: islogined ? const HomeScreen() : const TestScreen(),
    );
  }
}
