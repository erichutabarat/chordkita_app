import 'package:flutter/material.dart';

void main() {
  // Ensures widget binding is initialized if you add local storage or state management later
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
      home: const ChordHomeScreen(),
    );
  }
}

// --- INITIAL SCREEN PLACEHOLDER ---
class ChordHomeScreen extends StatelessWidget {
  const ChordHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Genjreng Chords'), elevation: 0),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Your chord library is getting ready...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
