import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  User? _user;
  bool _isAuthenticated = false;
  final ApiService _apiService = ApiService(baseUrl: "http://192.168.35.223:8000");

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String username, String password) async {
    try {
      print('Attempting login with username: $username');
      final user = await _apiService.login(username, password);
      _user = user;
      _isAuthenticated = true;
      await storage.write(key: 'user_id', value: user.id.toString());
      notifyListeners();
      print('Login successful, user: $_user');
    } catch (e) {
      print('Login failed: $e');
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
      throw e;
    }
  }

  Future<void> signup(String username, String password, String name, String email, String gender) async {
    try {
      final newUser = User(
        id: 0, // 서버에서 생성된 ID는 나중에 채워질 것입니다.
        username: username,
        password: password,
        name: name,
        email: email,
        gender: gender,
      );
      print('Attempting signup with username: $username');
      final user = await _apiService.signup(newUser);
      _user = user;
      _isAuthenticated = true;
      await storage.write(key: 'user_id', value: user.id.toString());
      notifyListeners();
      print('Signup successful, user: $user');
    } catch (e) {
      print('Signup failed: $e');
      throw e;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'user_id');
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}
