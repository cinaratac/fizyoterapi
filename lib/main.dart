// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart'; 
// Not: FirebaseOptions dosyasını projenizin kök dizinine manuel olarak eklemeniz gerekir.

void main() async {
  // Flutter binding'lerinin başlatıldığından emin olun
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase'i başlatın
  // TODO: Eğer Firebase'i kullanıyorsanız, 'firebase_options.dart' dosyasını oluşturun ve
  // varsayılan Firebase seçenekleriyle başlatın.
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Android projesindeki turuncu rengi (@color/orange: #FF9800) Flutter temasına dahil ediyoruz
    const orangeColor = Color(0xFFFF9800); 

    return MaterialApp(
      title: 'Fizyoterapi Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Uygulamanın genel rengini ve temasını ayarlayın
        colorScheme: ColorScheme.fromSeed(seedColor: orangeColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: orangeColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: orangeColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: const Size(200, 48), // Butonların genel boyutunu ayarlayın
          ),
        ),
      ),
      // İlk ekran olarak LoginScreen'i ayarlayın
      home: const LoginScreen(), 
    );
  }
}