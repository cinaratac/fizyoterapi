// lib/fragments/recycler_fragment.dart

import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../screens/hasta_movement_screen.dart'; 

class RecyclerFragment extends StatefulWidget {
  final String userPhone;
  const RecyclerFragment({super.key, required this.userPhone});

  @override
  State<RecyclerFragment> createState() => _RecyclerFragmentState();
}

class _RecyclerFragmentState extends State<RecyclerFragment> {
  late List<RecyclerData> dataList;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    // Kotlin'deki sabit listeyi buraya taşıyoruz.
    // Resimlerin assets klasöründe olduğunu varsayıyoruz.
    dataList = [
      RecyclerData(image: 'assets/kol_egzersizi.png', title: "Kol Egzersizi"),
      RecyclerData(image: 'assets/bacak_egzersizi.png', title: "Bacak Egzersizi"),
      RecyclerData(image: 'assets/boyun_egzersizi.png', title: "Boyun Egzersizi"),
      RecyclerData(image: 'assets/sirt_egzersizi.png', title: "Sırt Egzersizi"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final data = dataList[index];
          
          // Kotlin'deki 'card_layout' tasarımının Flutter karşılığı
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              // Resim gösterme kısmı
              leading: Image.asset(
                data.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.fitness_center, color: Colors.orange, size: 40);
                },
              ),
              title: Text(
                data.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Harekete başlamak için tıklayın"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Tıklanınca Hareket Takip Ekranına git
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HastaMovementScreen(userPhone: widget.userPhone),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}