// lib/screens/hasta_navigation_screen.dart
import '../fragments/recycler_fragment.dart';
import 'package:flutter/material.dart';
import '../fragments/settings_fragment.dart';
import 'hasta_movement_screen.dart'; 

class HastaNavigationScreen extends StatefulWidget {
  // Giriş/Login ekranından gelen hasta telefon numarasını tutar
  final String userPhone;

  const HastaNavigationScreen({super.key, required this.userPhone});

  @override
  State<HastaNavigationScreen> createState() => _HastaNavigationScreenState();
}

class _HastaNavigationScreenState extends State<HastaNavigationScreen> {
  int _selectedIndex = 0;

  // Navigasyon menüsündeki seçeneklere karşılık gelen Widget'lar (Fragment'lar)
  late final List<Widget> _fragments;

 @override
  void initState() {
    super.initState();
    // Fragment listesini, kullanıcı telefon numarasını hareket ekranına geçirerek başlat
    _fragments = [
      // Index 0: Hareket Takibi (Home, varsayılan)
      HastaMovementScreen(userPhone: widget.userPhone), 
      
      // Index 1: Hareket Listesi (Gallery) -> RecyclerFragment
      RecyclerFragment(userPhone: widget.userPhone), 
      
      // Index 2: Ayarlar Fragment
      const SettingsFragment(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Drawer'ı kapat
  }
  
  void _handleExit() {
    // Exit Activity'nin karşılığı: Login ekranına dön
    Navigator.of(context).popUntil((route) => route.isFirst); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasta Paneli'),
        backgroundColor: const Color(0xFFFF9800),
      ),
      // Fragment Container'ın karşılığı
      body: _fragments[_selectedIndex], 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // hasta_header.xml'in karşılığı
            UserAccountsDrawerHeader( 
              accountName: Text('Hasta: ${widget.userPhone}'),
              accountEmail: const Text('Fizyoterapi Takip Sistemi'),
              decoration: const BoxDecoration(color: Color(0xFFFF9800)),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Hareket Takibi (Home)'), // nav_home
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Hareket Listesi (Gallery)'), // nav_gallery
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'), // nav_settings
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış'), // nav_exit
              onTap: _handleExit,
            ),
          ],
        ),
      ),
    );
  }
}