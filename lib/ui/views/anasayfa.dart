import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_sepetim/data/entity/yemekler.dart';
import 'package:yemek_sepetim/toast/toast.dart';
import 'package:yemek_sepetim/ui/cubit/anasayfa_cubit.dart';
import 'package:yemek_sepetim/ui/views/yemek_detay_sayfa.dart';
import 'package:yemek_sepetim/user_auth/login_page.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController aramaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().yemekleriYukle();
    aramaController.addListener(() {
      context.read<AnasayfaCubit>().aramaYap(aramaController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB407C),
        title: const Text("Yemekler",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: (){
            _auth.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const KayitOlGirisYap()),
            );
            showToast(message: "Başarıyla çıkış yapıldı.");
          }, icon: const Icon(Icons.power_settings_new,color: Colors.white,)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
            child: TextField(
              controller: aramaController,
              onChanged: (aramaMetni) {
                context.read<AnasayfaCubit>().aramaYap(aramaMetni);
              },
              decoration: const InputDecoration(
                hintText: "Ne yesem?",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AnasayfaCubit, List<Yemekler>>(
              builder: (context, yemeklerListesi) {
                if (yemeklerListesi.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1/1.4,
                    ),
                    itemCount: yemeklerListesi.length,
                    itemBuilder: (context, indeks) {
                      var yemek = yemeklerListesi[indeks];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => YemekDetaySayfa(yemek: yemek)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(8.0),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}",width: 150,
                                  ),
                                  Text(yemek.yemek_adi,
                                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xFF352F44))),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                                        child: Text("${yemek.yemek_fiyat} ₺",
                                            style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Color(0xFF352F44))),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_box),
                                        color: Colors.deepPurpleAccent,
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => YemekDetaySayfa(yemek: yemek)));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        ),

                      );
                    },
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

