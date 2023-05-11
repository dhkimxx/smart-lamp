import 'package:client/screens/home_screen.dart';
import 'package:client/screens/join_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:flutter/material.dart';

void navigateToHomeScreen(context) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false);
}

void navigateToJoinScreen(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const JoinScreen(),
    ),
  );
}

void navigateToLoginScreen(context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
    (route) => false,
  );
}
