import 'package:client/navigator/screen_navigator.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/mqtt_service.dart';
import 'package:client/models/unit_model.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitDetailScreen extends StatefulWidget {
  final UnitModel unit;

  const UnitDetailScreen({
    super.key,
    required this.unit,
  });

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class SliderController {
  double sliderValue;
  SliderController(this.sliderValue);
}

class _UnitDetailScreenState extends State<UnitDetailScreen> {
  MyMqttClient myMqttClient = MyMqttClient();

  late SharedPreferences prefs;
  late Map<String, dynamic> userInfo;
  int inputDistance = 50; //cm
  int inputTime = 10; //sec
  int inputBrightness = 5;

  Future initPrefs() async {
    myMqttClient.connect();
    userInfo = await getUserPrefs();
    inputDistance = widget.unit.distance;
    inputTime = widget.unit.time;
    inputBrightness = widget.unit.brightness;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    SliderController sliderController =
        SliderController(inputBrightness.toDouble());

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/sky.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.purple[100],
          title: Text(
            widget.unit.unitName,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              '디바이스 코드: ${widget.unit.unitCode}',
              style: TextStyle(
                color: Colors.purple[100],
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          myMqttClient.publishMessage(
                            topic: widget.unit.unitCode,
                            msg: 'ON',
                          );
                        },
                        child: const Text(
                          'ON',
                          style: TextStyle(
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          myMqttClient.publishMessage(
                            topic: widget.unit.unitCode,
                            msg: 'OFF',
                          );
                        },
                        child: const Text(
                          'OFF',
                          style: TextStyle(
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  const Text(
                    '밝기 조절',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Slider(
                      activeColor: Colors.purple,
                      inactiveColor: Colors.purple[200],
                      thumbColor: Colors.purple,
                      value: sliderController.sliderValue,
                      min: 0.0,
                      max: 10.0,
                      divisions: 10,
                      label: '${sliderController.sliderValue.round()}',
                      onChanged: (double value) {
                        sliderController.sliderValue = value;
                        inputBrightness = value.toInt();
                        myMqttClient.publishMessage(
                          topic: 'setBrightness/${widget.unit.unitCode}',
                          msg: '$inputBrightness',
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        ' 감지 거리(cm):  ',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '$inputDistance',
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                showMaterialNumberPicker(
                  maxLongSide: 400,
                  title: '감지 거리',
                  context: context,
                  minNumber: 1,
                  maxNumber: 100,
                  selectedNumber: inputDistance,
                  onChanged: (value) => setState(() {
                    inputDistance = value;
                    myMqttClient.publishMessage(
                      topic: 'setDistance/${widget.unit.unitCode}',
                      msg: '$inputDistance',
                    );
                  }),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '점등 지속시간(초):  ',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '$inputTime',
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                showMaterialNumberPicker(
                  maxLongSide: 400,
                  title: '점등 지속시간',
                  context: context,
                  minNumber: 1,
                  maxNumber: 100,
                  selectedNumber: inputTime,
                  onChanged: (value) => setState(() {
                    inputTime = value;
                    myMqttClient.publishMessage(
                      topic: "setTime/${widget.unit.unitCode}",
                      msg: '$inputTime',
                    );
                  }),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                child: const Text(
                  '저장',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  try {
                    loadingDialog(context: context, text: '디바이스 정보를 수정하는중...');
                    UnitModel newUnit = UnitModel(
                      unitCode: widget.unit.unitCode,
                      unitName: widget.unit.unitName,
                      distance: inputDistance,
                      time: inputTime,
                      brightness: inputBrightness,
                      userId: userInfo['userId'],
                    );
                    print(newUnit.toJson());
                    patchUnitInfo(newUnit);
                    if (!mounted) return;
                    navigateToHomeScreen(context);
                  } on Exception catch (e) {
                    navigateToHomeScreen(context);
                    alterDialog(
                        context: context, title: 'error', contents: '$e');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
