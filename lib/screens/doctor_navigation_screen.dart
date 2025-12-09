// lib/screens/doctor_navigation_screen.dart

import 'package:flutter/material.dart';
import '../fragments/hasta_list_fragment.dart';
import '../fragments/settings_fragment.dart';

class DoctorNavigationScreen extends StatefulWidget {
  const DoctorNavigationScreen({super.key});

  @override
  State<DoctorNavigationScreen> createState() => _DoctorNavigationScreenState();
}

class _DoctorNavigationScreenState extends State<DoctorNavigationScreen> {
  int _selectedIndex = 0;
  
  // Doktornavigasyon.kt'deki replaceFragment mantığının karşılığı
  final List<Widget> _fragments = [
    const HastaListFragment(), // nav_home'a tıklandığında yüklenir
    const SettingsFragment(),  // nav_setting'e tıklandığında yüklenir
  ];

  void _onItemTapped(int index) {
    if (index == 2) { // Exit (Çıkış)
      _handleExit();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Drawer'ı kapat
  }
  
  void _handleExit() {
    // finish() karşılığı, Login ekranına döner
    Navigator.of(context).popUntil((route) => route.isFirst); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doktor Paneli'),
        // activity_doktornavigasyon.xml'deki @color/orange
        backgroundColor: const Color(0xFFFF9800), 
      ),
      // Fragment Container'ın karşılığı
      body: _fragments[_selectedIndex], 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // nav_header.xml'in karşılığı
            const UserAccountsDrawerHeader( 
              accountName: Text('Eyyüp Yılmaz'),
              accountEmail: Text('eyyup@example.com'),
              decoration: BoxDecoration(color: Color(0xFFFF9800)),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Hastalarım (Home)'), // nav_home
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'), // nav_setting
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış'), // nav_exit
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}