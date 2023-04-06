import 'dart:convert';

import 'package:client/widgets/alter_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUnitScreen extends StatefulWidget {
  const AddUnitScreen({super.key});

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  String? inputUnitCode;
  String? inputUnitName;
  int defaultDistance = 50;
  int defaultTime = 10000;
  Map<String, dynamic> unitInfoJson = {};
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final unitCodes = prefs.getStringList("unitCodes");
    if (unitCodes != null) {
    } else {
      prefs.setStringList("unitCodes", []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    createDevice(String? unitCode, String? unitName) {
      final unitCodes = prefs.getStringList("unitCodes");
      if (unitCode == null || unitCode == '') {
        alterDialog(context, '오류', '디바이스의 고유 코드를 입력하세요.');
        return;
      } else if (unitName == null || unitName == '') {
        alterDialog(context, '오류', '사용할 디바이스 이름(별명)을 입력하세요.');
        return;
      } else if (unitCodes!.contains(unitCode)) {
        alterDialog(context, '오류', '이미 등록된 디바이스의 고유 코드입니다.');
        return;
      } else {
        unitCodes.add(unitCode);
        prefs.setStringList('unitCodes', unitCodes);
        unitInfoJson = {
          'code': unitCode,
          'name': unitName,
          'distance': defaultDistance,
          'time': defaultTime,
        };
        prefs.setString(unitCode, json.encode(unitInfoJson));
      }
      Navigator.pop(context);
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                      createDevice(inputUnitCode, inputUnitName);
                    },
                    child: const Text(
                      '디바이스 생성',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
