import 'package:client/button/add_unit_button.dart';
import 'package:client/models/unit_model.dart';
import 'package:client/navigator/screen_navigator.dart';
import 'package:client/screens/add_unit_screen.dart';
import 'package:client/screens/unit_detail_screen.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/login_logout_service.dart';
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
  late bool isInitialized = false;
  List<UnitModel> unitModelList = [];
  late Map<String, dynamic> userInfo = {};
  late String userName = "";

  Future initPrefs() async {
    try {
      unitModelList = await getUnitModelList();
      userInfo = await getUserPrefs();
      userName = userInfo["userName"].toString();
      isInitialized = true;
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
    if (!isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              width: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/tukorea.jpg"),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        title: const Text(
          "Smart Lamp",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
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
                vertical: 10,
              ),
              child: Text(
                "$userName님, 안녕하세요.",
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
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
                    onDismissed: (direction) {
                      unitDeleteAlterDialog(context: context, unit: unit);
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
              child: const Text(
                "로그아웃",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
