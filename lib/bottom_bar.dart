import 'package:flutter/material.dart';
import 'package:yemek_sepetim/ui/views/anasayfa.dart';
import 'package:yemek_sepetim/ui/views/favoriler.dart';
import 'package:yemek_sepetim/ui/views/sepet_sayfa.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int secilenIndeks = 0;
  var sayfalar = [const Anasayfa(), const FavorilerSayfasi() ,const Sepet()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfalar[secilenIndeks],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Anasayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: "Favorilerim"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Sepetim"),
        ],
        currentIndex: secilenIndeks,
        backgroundColor: const Color(0xFFFB407C),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        onTap: (indeks){
          setState(() {
            secilenIndeks = indeks;
          });
        },
      ),
    );
  }
}
