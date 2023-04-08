import 'package:client/models/unit_model.dart';
import 'package:client/screens/unit_detail_screen.dart';
import 'package:flutter/material.dart';

class Unit extends StatelessWidget {
  final UnitModel unit;

  const Unit({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitDetailScreen(
              unit: unit,
            ),
          ),
        );
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
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lightbulb,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    unit.unitName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
