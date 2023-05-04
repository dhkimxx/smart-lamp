import 'package:client/screens/home_screen.dart';
import 'package:client/screens/join_screen.dart';
import 'package:client/service/login_service.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/alter_dialog_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _userPwController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _userPwController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final userId = _userIdController.text;
      final userPw = _userPwController.text;

      try {
        final userInfo = await loginUser(userId, userPw);
        setUserInfoPrefs(userInfo);
        setIsLoginedPrefs(true);
        _navigateToHomeScreen();
      } on Exception catch (e) {
        alterDialog(context: context, title: "Error", contents: "$e");
      }
    }
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '로그인',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _userIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '사용자 아이디를 입력하세요.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: '아이디',
                ),
              ),
              TextFormField(
                controller: _userPwController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '사용자 비밀번호를 입력하세요.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: '비밀번호',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const JoinScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
