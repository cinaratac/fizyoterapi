// lib/fragments/hasta_list_fragment.dart

import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/data_models.dart';
import '../screens/hasta_info_screen.dart'; // Yeni oluşturulacak

class HastaListFragment extends StatelessWidget {
  const HastaListFragment({super.key});

  // Hasta listesini çeken ve gösteren yapı
  @override
  Widget build(BuildContext context) {
    final db = DatabaseHelper.instance;

    return FutureBuilder<List<String>>(
      // Tüm hasta telefonlarını çek
      future: db.getAllHastaPhones(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        }
        
        final phoneList = snapshot.data ?? [];
        
        if (phoneList.isEmpty) {
          return const Center(child: Text('Kayıtlı hasta bulunmamaktadır.'));
        }

        // RecyclerView/Adapter mantığı burada ListView.builder ile uygulanır
        return ListView.builder(
          itemCount: phoneList.length,
          itemBuilder: (context, index) {
            final phone = phoneList[index];
            final hastaData = HastaData(image: 0, title: phone); // image sabit, title phone numarası
            
            return ListTile(
              leading: const Icon(Icons.person, color: Colors.blue), // ic_launcher_background yerine basit icon
              title: Text(hastaData.title), // itemEditTextHasta
              onTap: () {
                // Tıklama olayı: hastabilgi Activity'ye yönlendirme
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HastaInfoScreen(phone: phone),
                ));
              },
            );
          },
        );
      },
    );
  }
}