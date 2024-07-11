import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('마이 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('이름: ${auth.user?.name ?? 'Unknown'}'),
            Text('성별: ${auth.user?.gender ?? 'Unknown'}'),
            Text('아이디: ${auth.user?.username ?? 'Unknown'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                auth.logout();
                // 로그아웃 후 로그인 페이지로 이동하는 등 추가 작업
              },
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
