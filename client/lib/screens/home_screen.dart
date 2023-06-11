import 'dart:ui';

import 'package:client/models/unit_model.dart';
import 'package:client/navigator/screen_navigator.dart';
import 'package:client/screens/add_unit_screen.dart';
import 'package:client/screens/unit_detail_screen.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/dialog_widget.dart';
import 'package:client/widgets/unit_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UnitModel> unitModelList = [];
  late Map<String, dynamic> userInfo = {};
  late String userName = "";

  Future initPrefs() async {
    try {
      unitModelList = await getUnitModelList();
      userInfo = await getUserPrefs();
      userName = userInfo["userName"].toString();
    } on Exception catch (e) {
      alterDialog(context: context, title: 'error', contents: '$e');
    }
    setState(() {});
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/sky.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            foregroundColor: Colors.purple[100],
            backgroundColor: Colors.transparent,
            title: const Text(
              "Smart Lamp",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.account_tree_outlined),
              )
            ],
          ),
          drawer: const NavigationDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Text(
                    "$userName님, 안녕하세요.",
                    style: TextStyle(
                      color: Colors.purple[100],
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                for (var unit in unitModelList)
                  Column(
                    children: [
                      Dismissible(
                        key: Key(unit.unitCode),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          try {
                            loadingDialog(
                                context: context, text: "디바이스 삭제중...");
                            await deleteUnitInfo(unit);
                            if (mounted) Navigator.pop(context);
                          } on Exception catch (e) {
                            navigateToHomeScreen(context);
                            alterDialog(
                                context: context,
                                title: "error",
                                contents: "$e");
                          }
                        },
                        confirmDismiss: (direction) {
                          return confirmDismissAlterDialog(
                              context, "디바이스 삭제 확인");
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: const Text(
                            "삭제  ",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UnitDetailScreen(
                                  unit: unit,
                                ),
                              ),
                            ).then((value) => initPrefs());
                          },
                          child: Unit(
                            unit: unit,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddUnitScreen(),
                        ),
                      ).then((value) => initPrefs());
                    },
                    child: const AddUnitButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddUnitButton extends StatelessWidget {
  const AddUnitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_sharp,
            size: 70,
            color: Colors.purple[300],
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Drawer(
        backgroundColor: const Color.fromARGB(255, 50, 24, 55),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                loadingDialog(context: context, text: "로그아웃중...");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                try {
                  await logoutUser();
                  await prefs.clear();
                  navigateToLoginScreen(context);
                } on Exception catch (e) {
                  await prefs.clear();
                  navigateToLoginScreen(context);
                  alterDialog(context: context, title: "Error", contents: "$e");
                }
              },
              child: Text(
                "로그아웃",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.purple[100],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
