// lib/screens/login_screen.dart
import 'hasta_navigation_screen.dart';
import 'package:flutter/material.dart';
import '../services/database_helper.dart'; 
// import 'register_screen.dart', 'hasta_navigation_screen.dart', 'doktor_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(); 
  final _passwordController = TextEditingController(); 
  final DatabaseHelper db = DatabaseHelper.instance;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleLogin() async {
    final number = _phoneController.text;
    final password = _passwordController.text;

    // ... (Boş kontrolü)

    // SQLite ile Hasta Kontrolü
    final isHastaValid = await db.checkHasta(number, password);

    if (isHastaValid) {
      if (mounted) {
        // BAŞARILI GİRİŞ: Hasta Navigasyon Ekranına yönlendir
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HastaNavigationScreen(userPhone: number),
          ),
        );
      }
    } else {
      // Hata mesajı
      _showSnackbar("TELEFON VEYA ŞİFRE HATALI"); 
    }
}

  @override
  Widget build(BuildContext context) {
    // activity_main.xml'deki görünüm yapısı 
    return Scaffold(
      body: Container(
        // Arka plan: @drawable/fizyogiris.PNG
        decoration: const BoxDecoration(color: Color(0xFFE94E1B)), 
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ... TextFields (_phoneController, _passwordController) ...
            
            // Kaydol butonu: kaydol Activity'ye gider
            TextButton(onPressed: () { /* Navigator.of(context).push(...) */ }, 
                       child: const Text('Kayıt ol', style: TextStyle(color: Colors.white))),

            // GİRİŞ butonu: _handleLogin fonksiyonunu çağırır
            ElevatedButton(onPressed: _handleLogin, child: const Text('GİRİŞ')),

            // DOKTORUM butonu: DoktorGiris Activity'ye gider
            ElevatedButton(onPressed: () { /* Navigator.of(context).push(...) */ }, 
                           child: const Text('DOKTORUM')),
          ],
        ),
      ),
    );
  }
}