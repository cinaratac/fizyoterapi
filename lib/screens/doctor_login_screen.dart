// ...existing code...
import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper db = DatabaseHelper.instance;

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _handleLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showSnackbar("Lütfen tüm alanları doldurun");
      return;
    }

    // Eğer DatabaseHelper içinde doktor doğrulama için ayrı bir fonksiyon varsa onu kullanın.
    // Örnek: final isDoctorValid = await db.checkDoctor(phone, password);
    final isDoctorValid = await db.checkHasta(phone, password); // yoksa mevcut fonksiyonu değiştirin

    if (isDoctorValid) {
      // Başarılı giriş: gerekli yönlendirmeyi buraya ekleyin.
    } else {
      _showSnackbar("Telefon veya şifre hatalı");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doktor Girişi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Telefon')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Şifre')),
            ElevatedButton(onPressed: _handleLogin, child: const Text('GİRİŞ')),
          ],
        ),
      ),
    );
  }
}
// ...existing code...