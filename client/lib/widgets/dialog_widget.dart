import 'dart:convert';

import 'package:client/models/unit_model.dart';
import 'package:client/navigator/screen_navigator.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/prefs_service.dart';
import 'package:flutter/material.dart';

void alterDialog({
  required context,
  required String title,
  required String contents,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Column(
            children: <Widget>[
              Text(title),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contents,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

void loadingDialog({
  required context,
  required String text,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(text),
          ],
        ),
      );
    },
  );
}

void unitDeleteAlterDialog({
  required context,
  required UnitModel unit,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Column(
          children: const <Widget>[
            Text("디바이스 삭제"),
          ],
        ),
        //
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              "정말 디바이스를 삭제하시겠습니까?",
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("취소"),
                onPressed: () {
                  navigateToHomeScreen(context);
                },
              ),
              TextButton(
                child: const Text("확인"),
                onPressed: () async {
                  try {
                    loadingDialog(context: context, text: "디바이스 삭제중...");
                    await deleteUnitPrefs(unit.unitCode);
                    await deleteUnitInfo(unit);
                    final userInfo = jsonEncode(await getUserPrefs());
                    await putUserInfo(userInfo);
                    navigateToHomeScreen(context);
                  } on Exception catch (e) {
                    navigateToHomeScreen(context);
                    alterDialog(
                        context: context, title: "Error", contents: "$e");
                  }
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
