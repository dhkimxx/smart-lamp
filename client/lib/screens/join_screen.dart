import 'package:client/screens/home_screen.dart';
import 'package:client/service/join_service.dart';
import 'package:client/widgets/alter_dialog_widget.dart';
import 'package:flutter/material.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  void _join() async {
    if (_formKey.currentState!.validate()) {
      final userId = _usernameController.text;
      final userPw = _passwordController.text;
      final userPwCheck = _passwordCheckController.text;

      if (userPw != userPwCheck) {
        alterDialog(
          context: context,
          title: '오류',
          contents: '비밀번호을 다시 확인하세요.',
        );
        return;
      }

      try {
        print("$userId, $userPw");
        final token = await joinUser(userId, userPw);
        _navigateToHomeScreen();
        // 로그인 성공 시 처리할 코드 작성
      } catch (e) {
        // 로그인 실패 시 처리할 코드 작성
        print("회원가입 실패");
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
          '회원가입',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: '아이디',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: '비밀번호',
                ),
              ),
              TextFormField(
                controller: _passwordCheckController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: '비밀번호 확인',
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _join,
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
