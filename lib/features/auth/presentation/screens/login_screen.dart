import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onNavigateToRegister;
  const LoginScreen({super.key, required this.onNavigateToRegister});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text('Login Screen')]),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: widget.onNavigateToRegister,
          child: Text('Go to Register'),
        ),
      ),
    );
  }
}
