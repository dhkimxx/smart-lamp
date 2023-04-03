import 'package:flutter/material.dart';

class AddUnitScreen extends StatelessWidget {
  const AddUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text(
          "디바이스 추가",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
