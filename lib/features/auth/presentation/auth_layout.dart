import 'package:chordkita/features/auth/presentation/screens/login_screen.dart';
import 'package:chordkita/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key});

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      LoginScreen(onNavigateToRegister: _toRegisterScreen),
      RegisterScreen(onNavigateToLogin: _toLoginScreen),
    ];
    return Scaffold(body: SafeArea(child: screens[_currentIndex]));
  }

  void _toLoginScreen() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _toRegisterScreen() {
    setState(() {
      _currentIndex = 1;
    });
  }
}
