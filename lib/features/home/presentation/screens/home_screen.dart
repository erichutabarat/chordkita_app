// ignore_for_file: deprecated_member_use

import 'package:chordkita/features/home/data/samples/chord_sample.dart';
import 'package:chordkita/features/home/presentation/widgets/chordlist_component.dart';
import 'package:chordkita/features/home/presentation/widgets/chordsearch_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 2),
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: const Text(
                  'Welcome to ChordKita!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 18),
            ChordSearchBar(
              readOnly: false,
              onChanged: (value) {
                if (kDebugMode) {
                  print('Searching for: $value');
                }
              },
            ),
            const SizedBox(height: 20),

            // Top Chord Section
            ChordListComponent(
              title: "🔥 Top Chords",
              items: topSongs,
              onSeeAllPressed: () {
                if (kDebugMode) {
                  print('See all top chords clicked');
                }
              },
            ),
            const SizedBox(height: 20),

            // Newly Added Chord Section
            ChordListComponent(
              title: "✨ Newly Added Songs",
              items: newlyAddedSongs,
              onSeeAllPressed: () {
                if (kDebugMode) {
                  print('See all newly added clicked');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
