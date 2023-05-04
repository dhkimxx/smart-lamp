import 'package:client/models/unit_model.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/alter_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUnitScreen extends StatefulWidget {
  const AddUnitScreen({super.key});

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  late SharedPreferences prefs;
  late List<String> unitList;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    unitList = await getUnitList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
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
        unitList.add(unitCode);
        await setUnitList(unitList);
        putUserInfo();
        UnitModel unit = UnitModel(
          unitCode: unitCode,
          unitName: unitName,
          distance: defaultDistance,
          time: defaultTime,
        );
        prefs.setString(unitCode, unit.toJsonString());
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
