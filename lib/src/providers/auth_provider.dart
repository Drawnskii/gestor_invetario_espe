import 'package:flutter/material.dart';
import '../services/auth/login_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  final LoginService _loginService = LoginService();

  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    checkAuthStatus();
  }

  Future<void> login(String username, String password) async {
    bool success = await _loginService.login(username, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _loginService.isLoggedIn();
    notifyListeners();
  }

  Future<void> logout() async {
    await _loginService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
