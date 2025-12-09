// lib/screens/doctor_login_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/database_helper.dart';
import 'doctor_register_screen.dart';
import 'doctor_navigation_screen.dart'; // Bir sonraki adımda oluşturacağınız ekran

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  // activity_doktor_giris.xml'deki EditText'lere karşılık gelen Controller'lar
  final _phoneController = TextEditingController(); // number
  final _passwordController = TextEditingController(); // paswword
  final DatabaseHelper db = DatabaseHelper.instance;

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _handleLogin() async {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Alanların boş olup olmadığını kontrol et
    if (phone.isEmpty || password.isEmpty) {
      _showSnackbar("Lütfen tüm alanları doldurun.");
      return;
    }

    // SQLite ile Doktor Kontrolü
    final isDoctorValid = await db.checkDoktor(phone, password);

    if (isDoctorValid) {
      if (mounted) {
        // Giriş başarılı: Doktornavigasyon ekranına yönlendir
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DoctorNavigationScreen())
        );
      }
    } else {
      // Hata mesajı
      _showSnackbar("TELEFON VEYA ŞİFRE HATALI");
    }

    // Kotlin dosyasındaki Firebase kontrol mantığı:
    final ref = FirebaseDatabase.instance.ref("doktorlar");
    ref.orderByChild("phone").equalTo(phone).once().then((DatabaseEvent event) {
        // Firebase ile ilgili ek kontrol/kayıt mantığı buraya eklenebilir.
        // Kotlin'deki asıl yönlendirme SQLite başarılı olduğunda yapıldığı için bu kısım opsiyoneldir.
    });
  }

  void _navigateToRegister() {
    // DoktorKaydol Activity'ye yönlendir
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DoctorRegisterScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doktor Giriş Sayfası')),
      // activity_doktor_giris.xml'deki ConstraintLayout'un basit Column karşılığı
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefon Numarası'), // number
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(labelText: 'Şifre'), // paswword
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('GİRİŞ'), // giris butonu
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _navigateToRegister,
              child: const Text('KAYDOL', style: TextStyle(color: Colors.black54)), // kaydol butonu
            ),
          ],
        ),
      ),
    );
  }
}