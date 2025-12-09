// lib/screens/doctor_register_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/database_helper.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _phoneController = TextEditingController(); // k_d_phone
  final _passwordController = TextEditingController(); // k_d_password
  final DatabaseHelper db = DatabaseHelper.instance;

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _handleRegister() async {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      return;
    }

    final hasDoctor = await db.checkDoktor(phone, password);

    if (hasDoctor) {
      _showSnackbar("Bu telefon numarasına sahip zaten bir doktor var"); //
    } else {
      // SQLite Kayıt
      await db.insertDoktor(phone, password);
      
      // Firebase Kayıt
      final ref = FirebaseDatabase.instance.ref("doktorlar");
      final newRef = ref.push();
      final user = {"phone": phone, "password": password};
      newRef.set(user);
    }
    
    if (mounted) {
      // DoktorGiris Activity'ye dön
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doktor Kaydı')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefon Numarası'), // k_d_phone
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Şifre'), // k_d_password
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _handleRegister,
              child: const Text('KAYDET'), // d_kaydet butonu
            ),
          ],
        ),
      ),
    );
  }
}