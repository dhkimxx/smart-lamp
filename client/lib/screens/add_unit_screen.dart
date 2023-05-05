import 'dart:convert';

import 'package:client/models/unit_model.dart';
import 'package:client/screens/home_screen.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';

class AddUnitScreen extends StatefulWidget {
  const AddUnitScreen({super.key});

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  late Map<String, dynamic> userInfo;
  late List<String> unitList;

  Future initPrefs() async {
    userInfo = await getUserPrefs();
    unitList = await getUnitListPrefs();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    String? inputUnitCode;
    String? inputUnitName;
    int defaultDistance = 50; //cm
    int defaultTime = 10; //sec

    createDevice({required String? unitCode, required String? unitName}) async {
      if (unitCode == null || unitCode == '') {
        alterDialog(
          context: context,
          title: '오류',
          contents: '디바이스의 고유 코드를 입력하세요.',
        );
        return;
      } else if (unitName == null || unitName == '') {
        alterDialog(
          context: context,
          title: '오류',
          contents: '사용할 디바이스 이름(별명)을 입력하세요.',
        );
        return;
      } else if (unitList.contains(unitCode)) {
        alterDialog(
          context: context,
          title: '오류',
          contents: '이미 등록된 디바이스의 고유 코드입니다.',
        );
        return;
      } else {
        UnitModel newUnit = UnitModel(
          unitCode: unitCode,
          unitName: unitName,
          distance: defaultDistance,
          time: defaultTime,
        );

        try {
          loadingDialog(context: context, text: "디바이스 정보를 등록하는 중...");
          await postUnitInfo(newUnit);
          final newUnitList = unitList;
          final newUserInfo = userInfo;
          newUnitList.add(unitCode);
          newUserInfo['unitList'] = newUnitList;
          await putUserInfo(jsonEncode(newUserInfo));
          await setUnitInfoPrefs(unitCode, newUnit.toJson());
          await setUserInfoPrefs(jsonEncode(newUserInfo));
          _navigateToHomeScreen();
        } on Exception catch (e) {
          Navigator.pop(context);
          alterDialog(context: context, title: "Error", contents: "$e");
        }
      }
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
                      createDevice(
                        unitCode: inputUnitCode,
                        unitName: inputUnitName,
                      );
                    },
                    child: const Text(
                      '디바이스 생성',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
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
