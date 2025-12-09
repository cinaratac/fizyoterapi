// lib/screens/doctor_navigation_screen.dart

import 'package:flutter/material.dart';
import '../fragments/hasta_list_fragment.dart';
import '../fragments/settings_fragment.dart';
import 'login_screen.dart'; // Çıkış yapınca dönülecek ekran

class DoctorNavigationScreen extends StatefulWidget {
  const DoctorNavigationScreen({super.key});

  @override
  State<DoctorNavigationScreen> createState() => _DoctorNavigationScreenState();
}

class _DoctorNavigationScreenState extends State<DoctorNavigationScreen> {
  int _selectedIndex = 0;
  
  // Menüdeki sayfalar
  final List<Widget> _pages = [
    const HastaListFragment(),
    const SettingsFragment(),
  ];

  // Sayfa başlıkları
  final List<String> _titles = [
    "Hastalarım",
    "Ayarlar"
  ];

  void _onItemTapped(int index) {
    if (index == 2) { // Çıkış İndeksi
      _handleLogout();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Menüyü kapat
  }
  
  void _handleLogout() {
    // Çıkış yap ve Login ekranına dön
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
            const UserAccountsDrawerHeader( 
              accountName: Text('Doktor Paneli'),
              accountEmail: Text('Hoşgeldiniz'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.medical_services, color: Color(0xFFFF9800)),
              ),
              decoration: BoxDecoration(color: Color(0xFFFF9800)),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Hastalarım'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}