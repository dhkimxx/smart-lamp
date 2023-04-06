import 'package:flutter/material.dart';

class AddUnitButton extends StatelessWidget {
  const AddUnitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.add_circle_sharp,
            size: 70,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
