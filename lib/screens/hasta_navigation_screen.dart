// lib/screens/hasta_navigation_screen.dart

import 'package:flutter/material.dart';
import '../fragments/recycler_fragment.dart';
import '../fragments/settings_fragment.dart';
import 'hasta_movement_screen.dart'; 
import 'login_screen.dart';

class HastaNavigationScreen extends StatefulWidget {
  final String userPhone;

  const HastaNavigationScreen({super.key, required this.userPhone});

  @override
  State<HastaNavigationScreen> createState() => _HastaNavigationScreenState();
}

class _HastaNavigationScreenState extends State<HastaNavigationScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  late final List<String> _titles;

  @override
  void initState() {
    super.initState();
    _pages = [
      HastaMovementScreen(userPhone: widget.userPhone), // Ana Sayfa: Hareket
      RecyclerFragment(userPhone: widget.userPhone),    // Galeri: Egzersiz Listesi
      const SettingsFragment(),                         // Ayarlar
    ];
    _titles = ["Hareket Takibi", "Egzersiz Listesi", "Ayarlar"];
  }

  void _onItemTapped(int index) {
    if (index == 3) { // Çıkış
        _handleLogout();
        return;
    }
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader( 
              accountName: Text('Hasta: ${widget.userPhone}'),
              accountEmail: const Text('Fizyoterapi Takip Sistemi'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFFFF9800)),
              ),
              decoration: const BoxDecoration(color: Color(0xFFFF9800)),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Hareket Takibi (Home)'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Egzersiz Listesi (Galeri)'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Çıkış'),
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}