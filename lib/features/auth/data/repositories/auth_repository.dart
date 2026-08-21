import 'package:chordkita/features/auth/domain/entities/user.dart';

class AuthRepository {
  // Simulasi Login
  Future<User> login({required String email, required String password}) async {
    // Simulasi delay request jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Validasi sederhana (dummy check)
    if (email == "user@gmail.com" && password == "123456") {
      return User(id: 1, email: email, name: "Eric Daniel");
    } else {
      throw Exception("Email atau password salah!");
    }
  }

  // Simulasi Register
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.contains("@") && password.length >= 6) {
      return User(id: 1, email: email, name: name);
    } else {
      throw Exception(
        "Format email tidak valid atau password kurang dari 6 karakter.",
      );
    }
  }
}
