// lib/screens/hasta_info_screen.dart (YENİ OLUŞTURULACAK)

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HastaInfoScreen extends StatefulWidget {
  // Hasta Listesi'nden gelen telefon numarasını tutar
  final String phone;

  const HastaInfoScreen({super.key, required this.phone});

  @override
  State<HastaInfoScreen> createState() => _HastaInfoScreenState();
}

class _HastaInfoScreenState extends State<HastaInfoScreen> {
  // Firebase referansı (hasta_kullanim)
  final ref = FirebaseDatabase.instance.ref("hasta_kullanim");

  // loadDailyUsage fonksiyonu (Kotlin'deki ValueEventListener'ın Stream karşılığı)
  Stream<String> loadDailyUsage(String phone) {
    // Firebase Realtime Database'deki veriyi dinler
    return ref.child(phone).onValue.map((event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      final builder = StringBuffer();

      if (data != null) {
        // Her bir günlük kullanım kaydı üzerinde döner
        data.forEach((key, value) {
          final date = value["date"] as String?;
          final totalTime = value["totalTime"] as int?; // Kotlin'deki Long karşılığı

          if (date != null && totalTime != null) {
            // Süreyi saniyeye çevirip formatlar
            final seconds = totalTime / 1000;
            builder.write("$date : ${seconds.toStringAsFixed(0)} saniye\n");
          }
        });
      }
      return builder.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.phone} Kullanım Bilgisi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Veriyi çekmek için StreamBuilder kullanıyoruz
        child: StreamBuilder<String>(
          stream: loadDailyUsage(widget.phone),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }

            // textViewBilgi'nin karşılığı
            return SingleChildScrollView( 
              child: Text(
                snapshot.data ?? 'Veri bulunamadı.',
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}