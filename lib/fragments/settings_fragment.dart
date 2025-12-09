// lib/fragments/settings_fragment.dart 

import 'package:flutter/material.dart';

class SettingsFragment extends StatelessWidget {
  const SettingsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    // fragment_home.xml'deki içeriğin karşılığı
    return const Center( 
      child: Text(
        "Ayarlar Sayfası", // Kotlin dosyasında Settings olarak kullanılmıştı
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}