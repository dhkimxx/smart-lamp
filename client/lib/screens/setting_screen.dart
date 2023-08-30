import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Open App Settings'),
        ),
      ),
    );
  }
}
