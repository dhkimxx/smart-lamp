import 'package:client/navigator/screen_navigator.dart';
import 'package:client/service/api_service.dart';
import 'package:client/service/prefs_service.dart';
import 'package:client/widgets/dialog_widget.dart';
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
        loadingDialog(context: context, text: "사용자 정보를 가져오는 중...");
        final userInfo = await loginUser(userId, userPw);
        await setUserInfoPrefs(userInfo);
        print(userInfo);
        await setIsLoginedPrefs(true);
        if (!mounted) return;
        navigateToHomeScreen(context);
      } on Exception catch (e) {
        Navigator.pop(context);
        alterDialog(context: context, title: "오류", contents: "$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '로그인',
            style: TextStyle(
              color: Colors.purple.shade100,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/child.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _userIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '사용자 아이디를 입력하세요.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: InputBorder.none,
                          labelText: '아이디',
                          labelStyle: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _userPwController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '사용자 비밀번호를 입력하세요.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: InputBorder.none,
                          labelText: '비밀번호',
                          labelStyle: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple, // 버튼의 배경색을 주황색으로 설정
                          ),
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
                            navigateToJoinScreen(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple, // 버튼의 배경색을 주황색으로 설정
                          ),
                          child: const Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
