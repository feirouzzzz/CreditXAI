import 'dart:async';

class AuthService {
  // Dummy login - replace with real HTTP calls
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if ((email == 'test@demo.com' && password == 'Password123!') ||
        (email == 'admin@demo.com' && password == 'Admin123!')) {
      return {
        'ok': true,
        'token': 'demo-token',
        'role': email == 'admin@demo.com' ? 'admin' : 'user',
      };
    }
    return {'ok': false, 'error': 'Invalid credentials'};
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
