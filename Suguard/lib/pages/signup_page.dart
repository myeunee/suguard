import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = context.read<AuthService>();
                try {
                  await authService.signup(
                    _usernameController.text,
                    _passwordController.text,
                    _nameController.text,
                    _emailController.text,
                    _genderController.text,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  // 에러 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signup failed: $e')),
                  );
                }
              },
              child: Text('회원가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}
