import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onNavigateToLogin;
  const RegisterScreen({super.key, required this.onNavigateToLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text('Register Screen')]),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: widget.onNavigateToLogin,
          child: Text('Go to Login'),
        ),
      ),
    );
  }
}
