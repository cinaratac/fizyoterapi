// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController(); // editTextPhone2
  final _passwordController = TextEditingController(); // editTextTextPassword
  final DatabaseHelper db = DatabaseHelper.instance;

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _handleRegister() async {
    final number = _phoneController.text;
    final password = _passwordController.text;

    if (number.isEmpty || password.isEmpty) {
      _showSnackbar("Lütfen tüm alanları doldurun"); //
      return;
    }

    final hasHasta = await db.checkHasta(number, password);
    
    if (hasHasta) {
      _showSnackbar("Bu telefon numarasına sahip zaten bir kullanıcı var"); //
    } else {
      // SQLite Kayıt
      await db.insertHasta(number, password);
      
      // Firebase Kayıt
      final ref = FirebaseDatabase.instance.ref("hastalar");
      final newRef = ref.push();
      final user = {"phone": number, "password": password};
      newRef.set(user);

      _showSnackbar("Kayıt Başarılı");
      if (mounted) {
        // MainActivity'ye dön (Flutter'da LoginScreen)
        Navigator.of(context).pop(); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasta Kaydı')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone, // editTextPhone2
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.text, // editTextTextPassword
              decoration: const InputDecoration(labelText: 'Şifre'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _handleRegister,
              child: const Text('KAYDET'), // kaydet butonu
            ),
          ],
        ),
      ),
    );
  }
}