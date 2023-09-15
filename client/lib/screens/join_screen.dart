import 'package:client/navigator/screen_navigator.dart';
import 'package:client/service/api_service.dart';
import 'package:client/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _userPwController = TextEditingController();
  final _userPwCheckController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _userPwController.dispose();
    _userPwCheckController.dispose();
    super.dispose();
  }

  void _join() async {
    if (_formKey.currentState!.validate()) {
      final userId = _userIdController.text;
      final userPw = _userPwController.text;
      final userName = _userNameController.text;
      final phone = _phoneController.text;

      try {
        loadingDialog(context: context, text: "사용자 등록 요청중...");
        await joinUser(userId, userPw, userName, phone);
        if (!mounted) return;
        navigateToLoginScreen(context);
        alterDialog(
          context: context,
          title: "회원가입 완료",
          contents: "회원가입이 완료되었습니다.",
        );
      } on Exception catch (e) {
        Navigator.pop(context);
        alterDialog(context: context, title: "Error", contents: "$e");
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            '회원가입',
            style: TextStyle(
              color: Colors.purple.shade100,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: BackButton(
            color: Colors.purple.shade100,
          ),
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
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _userNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '사용자 이름을 입력하세요.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: InputBorder.none,
                          labelText: '이름',
                          labelStyle: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '휴대폰 번호를 입력하세요.';
                          } else if (value.length != 11) {
                            return '01012345678 형식으로 입력하세요';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: InputBorder.none,
                          labelText: '휴대폰 번호',
                          labelStyle: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _userPwCheckController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 한번 사용자 비밀번호를 입력하세요.';
                          } else if (_userPwController.text !=
                              _userPwCheckController.text) {
                            return '비밀번호가 일치한지 확인하세요.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: InputBorder.none,
                          labelText: '비밀번호 확인',
                          labelStyle: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: _join,
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
                    ),
                    const SizedBox(height: 100),
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
