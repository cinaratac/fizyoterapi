// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'hasta_navigation_screen.dart';
import 'register_screen.dart';       // EKSİK OLAN SATIR 1
import 'doctor_login_screen.dart';   // EKSİK OLAN SATIR 2 (Hatanın Sebebi)

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
    final number = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (number.isEmpty || password.isEmpty) {
      _showSnackbar("Lütfen tüm alanları doldurun");
      return;
    }

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
      _showSnackbar("TELEFON VEYA ŞİFRE HATALI");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFFE94E1B),
            image: DecorationImage(
              image: AssetImage("assets/fizyogiris.PNG"), // Resmin assets klasöründe olduğundan emin ol
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "FİZYOTERAPİ",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Telefon Numarası',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
              
              // GİRİŞ BUTONU
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('GİRİŞ', style: TextStyle(color: Color(0xFFE94E1B))),
                ),
              ),
              
              const SizedBox(height: 10),

              // KAYIT OL BUTONU
              TextButton(
                onPressed: () {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterScreen())
                   );
                },
                child: const Text('Kayıt ol', style: TextStyle(color: Colors.white)),
              ),

              const SizedBox(height: 20),

              // DOKTORUM BUTONU (Hata veren kısım burasıydı)
              ElevatedButton(
                onPressed: () {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const DoctorLoginScreen())
                   );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                child: const Text('DOKTORUM', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}