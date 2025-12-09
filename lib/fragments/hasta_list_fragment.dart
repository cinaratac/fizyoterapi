// lib/fragments/hasta_list_fragment.dart

import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../screens/hasta_info_screen.dart';

class HastaListFragment extends StatefulWidget {
  const HastaListFragment({super.key});

  @override
  State<HastaListFragment> createState() => _HastaListFragmentState();
}

class _HastaListFragmentState extends State<HastaListFragment> {
  final DatabaseHelper db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FutureBuilder ile veritabanından verilerin gelmesini bekliyoruz
      body: FutureBuilder<List<String>>(
        future: db.getAllHastaPhones(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          
          final phoneList = snapshot.data ?? [];
          
          if (phoneList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Henüz kayıtlı hasta yok.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: phoneList.length,
            itemBuilder: (context, index) {
              final phone = phoneList[index];
              
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    phone, 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text("Detaylar için tıklayın"),
                  onTap: () {
                    // Hastanın detay sayfasına git
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HastaInfoScreen(phone: phone),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}