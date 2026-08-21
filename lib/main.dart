import 'package:chordkita/features/auth/presentation/auth_layout.dart';
import 'package:chordkita/features/home/presentation/home_layout.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GuitarChordApp());
}

class GuitarChordApp extends StatelessWidget {
  const GuitarChordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChordKita', // Or whatever brand name you choose!
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),

      // Starting screen
      initialRoute: '/home',
      routes: {
        '/auth': (context) => const AuthLayout(),
        '/home': (context) => const HomeLayout(),
      },
    );
  }
}
