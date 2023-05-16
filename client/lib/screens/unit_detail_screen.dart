import 'package:client/navigator/screen_navigator.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/mqtt_service.dart';
import 'package:client/models/unit_model.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
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

class _UnitDetailScreenState extends State<UnitDetailScreen> {
  late SharedPreferences prefs;
  late Map<String, dynamic> userInfo;
  int inputDistance = 50; //cm
  int inputTime = 10; //sec

  Future initPrefs() async {
    userInfo = await getUserPrefs();
    inputDistance = widget.unit.distance;
    inputTime = widget.unit.time;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    var myMqttClient = MyMqttClient();
    myMqttClient.connect();

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: Text(
          widget.unit.unitName,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blue,
                    )),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        myMqttClient.pubMessage(
                          topic: widget.unit.unitCode,
                          msg: 'ON',
                        );
                      },
                      child: const Text('ON'),
                    ),
                    TextButton(
                      onPressed: () {
                        myMqttClient.pubMessage(
                          topic: widget.unit.unitCode,
                          msg: 'OFF',
                        );
                      },
                      child: const Text('OFF'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          editDistance(myMqttClient),
          const SizedBox(
            height: 10,
          ),
          editTime(myMqttClient),
        ],
      ),
    );
  }

  Row editDistance(MyMqttClient myMqttClient) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          ' 감지 거리(cm):  ',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 50,
          height: 48,
          child: TextFormField(
            key: Key('$inputDistance'),
            autofocus: false,
            initialValue: '$inputDistance',
            textAlign: TextAlign.center,
            onChanged: (value) {
              if (value != '') inputDistance = int.parse(value);
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue),
          child: TextButton(
            onPressed: () async {
              try {
                loadingDialog(context: context, text: '디바이스 정보를 수정하는중...');
                myMqttClient.pubMessage(
                  topic: "setDistance/${widget.unit.unitCode}",
                  msg: '$inputDistance',
                );
                UnitModel newUnit = UnitModel(
                  unitCode: widget.unit.unitCode,
                  unitName: widget.unit.unitName,
                  distance: inputDistance,
                  time: widget.unit.time,
                  user: userInfo,
                );
                putUnitInfo(newUnit);
                if (!mounted) return;
                Navigator.pop(context);
              } on Exception catch (e) {
                navigateToHomeScreen(context);
                alterDialog(context: context, title: 'error', contents: '$e');
              }
            },
            child: const Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row editTime(MyMqttClient myMqttClient) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '점등 지속시간(초):',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 50,
          height: 48,
          child: TextFormField(
            key: Key('$inputTime'),
            autofocus: false,
            initialValue: '$inputTime',
            textAlign: TextAlign.center,
            onChanged: (value) {
              if (value != '') inputTime = int.parse(value);
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue),
          child: TextButton(
            onPressed: () async {
              try {
                loadingDialog(context: context, text: '디바이스 정보를 수정하는중...');
                myMqttClient.pubMessage(
                  topic: "setTime/${widget.unit.unitCode}",
                  msg: '$inputTime',
                );
                UnitModel newUnit = UnitModel(
                  unitCode: widget.unit.unitCode,
                  unitName: widget.unit.unitName,
                  distance: widget.unit.distance,
                  time: inputTime,
                  user: userInfo,
                );
                await putUnitInfo(newUnit);
                if (!mounted) return;
                Navigator.pop(context);
              } on Exception catch (e) {
                navigateToHomeScreen(context);
                alterDialog(context: context, title: 'error', contents: '$e');
              }
            },
            child: const Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
