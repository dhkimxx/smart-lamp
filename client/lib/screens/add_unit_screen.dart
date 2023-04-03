import 'package:flutter/material.dart';

class AddUnitScreen extends StatelessWidget {
  const AddUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? inputUnitCode;
    String? inputUnitName;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '디바이스 고유 코드',
                  ),
                  onChanged: (value) {
                    inputUnitCode = value;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '디바이스 이름 설정',
                  ),
                  onChanged: (value) {
                    inputUnitName = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    print('$inputUnitCode, $inputUnitName');
                  },
                  child: const Text(
                    '디바이스 생성',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
