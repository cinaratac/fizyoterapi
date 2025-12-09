// lib/fragments/recycler_fragment.dart

import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../screens/hasta_movement_screen.dart'; 
// HastaNavigationScreen'den gelen userPhone'u almalı.

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

  // Kotlin'deki setData fonksiyonunun karşılığı
  void setData() {
    // Kotlin dosyasındaki sabit veriler: title1, title2, title3, title4
    final titleList = ["title1", "title2", "title3", "title4"];
    dataList = titleList.map((title) => RecyclerData(image: 0, title: title)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // RecyclerView'in karşılığı
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final data = dataList[index];
        return ListTile(
          leading: const Icon(Icons.fitness_center, color: Colors.deepOrange),
          title: Text(data.title),
          subtitle: const Text("Yapılacak Egzersiz"),
          onTap: () {
            // R_adapter.kt'deki tıklama mantığı: hastahareket'e yönlendir
            Navigator.of(context).push(
              MaterialPageRoute(
                // Bu, hastanın toplam kullanım süresini takip eden ekran
                builder: (context) => HastaMovementScreen(userPhone: widget.userPhone),
              ),
            );
          },
        );
      },
    );
  }
}