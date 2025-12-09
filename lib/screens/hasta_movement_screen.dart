// lib/screens/hasta_movement_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Tarih formatlamak için intl paketi gerekebilir (pubspec.yaml'a eklemeyi unutmayın)

class HastaMovementScreen extends StatefulWidget {
  // Giriş/Login ekranından telefon numarasını alacak
  final String userPhone;

  const HastaMovementScreen({super.key, required this.userPhone});

  @override
  State<HastaMovementScreen> createState() => _HastaMovementScreenState();
}

// WidgetsBindingObserver, uygulamanın arka plana atılmasını (onPause) ve 
// ön plana gelmesini (onResume) takip etmek için kullanılır.
class _HastaMovementScreenState extends State<HastaMovementScreen> with WidgetsBindingObserver {
  
  // Zaman takip değişkenleri
  DateTime? _startTime;
  int _totalUsageTimeMs = 0; // Toplam kullanım süresi (milisaniye)
  
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref("hasta_kullanim");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Kotlin'deki onCreate/onResume başlangıcının karşılığı
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Uygulama yaşam döngüsü değişikliklerini yakalar (onResume, onPause, vb.)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Kotlin'deki onResume() karşılığı
      _startTimer();
    } else if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Kotlin'deki onPause() karşılığı
      _stopTimerAndSaveUsage();
    }
  }

  void _startTimer() {
    _startTime = DateTime.now();
  }

  void _stopTimerAndSaveUsage() {
    if (_startTime != null) {
      // Geçen süreyi hesapla (milisaniye)
      final duration = DateTime.now().difference(_startTime!);
      _totalUsageTimeMs = duration.inMilliseconds;
      _startTime = null; // Zamanlayıcıyı sıfırla

      // Firebase'e kaydet
      _saveDailyUsage();
    }
  }

  // Firebase'e günlük kullanım süresini kaydetme
  void _saveDailyUsage() {
    if (_totalUsageTimeMs == 0) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final userRef = _firebaseRef.child(widget.userPhone);
    
    // Güncel güne ait kaydı Firebase'de bul
    userRef.orderByChild("date").equalTo(today).once().then((DatabaseEvent event) {
      
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        // Mevcut kaydı güncelle (Eğer aynı gün içinde birden fazla oturum olursa)
        final Map data = snapshot.value as Map;
        final key = data.keys.first;
        final currentTotalTimeMs = data[key]['totalTime'] as int? ?? 0;
        
        // Yeni süreyi ekle
        final newTotalTimeMs = currentTotalTimeMs + _totalUsageTimeMs;

        // Firebase'e güncelle
        userRef.child(key).update({
          "totalTime": newTotalTimeMs,
        });

      } else {
        // Yeni kayıt oluştur
        final newKey = userRef.push().key;
        userRef.child(newKey!).set({
          "date": today,
          "totalTime": _totalUsageTimeMs,
        });
      }
      
      _totalUsageTimeMs = 0; // Kayıt sonrası sıfırla
      
    }).catchError((error) {
       debugPrint("Firebase'e kayıt hatası: $error");
    });
  }

  // Kullanım süresini dakika:saniye formatına dönüştürme
  String _formatTime(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    // activity_hastahareket.xml'in basit bir karşılığı
    return Scaffold(
      appBar: AppBar(title: const Text('Hasta Hareket Takibi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Fizik Tedavi Hareketi Takip Ediliyor...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Buraya, Kotlin uygulamasındaki gibi anlık süreyi gösteren bir sayaç eklenebilir.
            // (Mevcut Kotlin kodunda anlık sayaç yok, sadece toplam süre kaydediliyor)
            Image.asset(
              'assets/fizyoterapi.png', // Projenizde bu görselin assets/ klasöründe olması gerekir.
              height: 150,
            ),
            const SizedBox(height: 40),
            const Text(
              'Uygulamayı kapatmayın, arka plana atmak süreyi durduracaktır.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}