import 'package:chordkita/features/auth/domain/entities/user.dart';
import 'package:chordkita/features/home/presentation/screens/favorite_screen.dart';
import 'package:chordkita/features/home/presentation/screens/home_screen.dart';
import 'package:chordkita/features/home/presentation/screens/profile_screen.dart';
import 'package:chordkita/features/home/presentation/screens/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  final User? user;
  const HomeLayout({super.key, this.user});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentPage = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const SearchScreen(),
      const FavoriteScreen(),
      ProfileScreen(user: widget.user),
    ];
    if (kDebugMode) {
      print(widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentPage]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPage,
        onDestinationSelected: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_outlined),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
