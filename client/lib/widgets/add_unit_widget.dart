import 'package:client/screens/add_unit_screen.dart';
import 'package:flutter/material.dart';

class AddUnitWidget extends StatelessWidget {
  const AddUnitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddUnitScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: const Icon(
                Icons.add_circle_sharp,
                size: 70,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
