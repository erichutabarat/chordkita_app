// auth_repository.dart
import 'dart:convert';
import 'package:chordkita/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _userKey = 'cached_user_session';
  static const String _tokenKey = 'auth_token';

  Future<User?> checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();

    final userJsonStr = prefs.getString(_userKey);
    final token = prefs.getString(_tokenKey);

    if (userJsonStr != null && token != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJsonStr);
      return User.fromJson(userMap);
    }

    return null;
  }

  Future<void> saveSession({required User user, required String token}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // 3. CLEAR SESSION (Called on Logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  Future<User> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == "user@gmail.com" && password == "123456") {
      final user = User(id: 1, email: email, name: "Eric Daniel");
      const dummyToken = "jwt_token_xyz_123";

      await saveSession(user: user, token: dummyToken);

      return user;
    } else {
      throw Exception("Email atau password salah!");
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.contains("@") && password.length >= 6) {
      final user = User(id: 1, email: email, name: "Eric Daniel");
      const dummyToken = "jwt_token_xyz_123";

      await saveSession(user: user, token: dummyToken);

      return user;
    } else {
      throw Exception(
        "Format email tidak valid atau password kurang dari 6 karakter.",
      );
    }
  }
}
