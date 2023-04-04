import 'package:flutter/material.dart';

class Unit extends StatelessWidget {
  final String unitCode;

  const Unit({
    super.key,
    required this.unitCode,
  });
  onTap() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.lightbulb,
              size: 80,
              color: Colors.white,
            ),
            Text(
              unitCode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
