import 'package:client/screens/unit_detail_screen.dart';
import 'package:flutter/material.dart';

class Unit extends StatelessWidget {
  final String unitCode;
  final String unitName;

  const Unit({
    super.key,
    required this.unitCode,
    required this.unitName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UnitDetailScreen(
                      unitCode: unitCode,
                      unitName: unitName,
                    )));
      },
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
              unitName,
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
