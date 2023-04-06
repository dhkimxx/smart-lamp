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
      if (unitCode == null || unitName == null) {
        return;
      }
      final unitCodes = prefs.getStringList("unitCodes");
      if (unitCodes!.contains(unitCode)) {
      } else {
        unitCodes.add(unitCode);
        prefs.setStringList('unitCodes', unitCodes);
        prefs.setString(unitCode, unitName);
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
