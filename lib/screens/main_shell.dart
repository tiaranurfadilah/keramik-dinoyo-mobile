import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'placeholder_screens.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onNavigate: _go),
      const PlaceholderScreen(
        title: 'Jelajah',
        description: 'Daftar karya dan toko lokal akan dibuat di tahap berikutnya.',
        icon: Icons.explore_outlined,
      ),
      const PlaceholderScreen(
        title: 'Kegiatan',
        description: 'Workshop dan form pendaftaran akan dibuat di tahap berikutnya.',
        icon: Icons.palette_outlined,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: _go,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.brown,
          selectedLabelStyle: AppText.sans(size: 12, weight: FontWeight.w700),
          unselectedLabelStyle: AppText.sans(size: 12, weight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Jelajah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.palette_outlined),
              activeIcon: Icon(Icons.palette),
              label: 'Kegiatan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}