import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:yemek_sepetim/bottom_bar.dart';
import 'package:yemek_sepetim/data/entity/sepettekiler.dart';
import 'package:yemek_sepetim/ui/cubit/sepet_sayfa_cubit.dart';

class Sepet extends StatefulWidget {
  const Sepet({super.key});

  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final AnimationController _lottieController;
  double toplamTutar = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<SepetSayfaCubit>().sepettekiYemekleriGetir(_auth.currentUser?.email ?? "",);
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _lottieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB407C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const BottomBar()));
          },
        ),
        centerTitle: true,
        title: const Text(
          "Sepetim",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<SepetSayfaCubit, List<Sepettekiler>>(
        builder: (context, sepettekiUrunler) {
          toplamTutar = context.read<SepetSayfaCubit>().getToplamTutar();
          if (sepettekiUrunler.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: sepettekiUrunler.length,
                    itemBuilder: (context, index) {
                      var urun = sepettekiUrunler[index];
                      return Container(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                              width: 150,
                              "http://kasimadalan.pe.hu/yemekler/resimler/${urun.yemek_resim_adi}",
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  urun.yemek_adi,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF352F44),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Adet: ${urun.yemek_siparis_adet}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Fiyat: ${urun.yemek_fiyat} ₺",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF352F44),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<SepetSayfaCubit>()
                                        .sepettenSil(int.parse(urun.sepet_yemek_id), urun.kullanici_adi);
                                    _lottieController.reset();
                                    showDialog(
                                      barrierColor: Colors.white54,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          content: Lottie.asset(
                                            'assets/lottie/delete.json',
                                            width: 200,
                                            height: 200,
                                            controller: _lottieController,
                                            onLoaded: (composition) {
                                              _lottieController
                                                ..duration = composition.duration
                                                ..forward();
                                              Future.delayed(
                                                Duration(seconds: composition.duration.inSeconds),
                                                    () {
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.deepPurpleAccent,
                                    size: 35,
                                  ),
                                ),
                                Text(
                                  '${(int.parse(urun.yemek_fiyat) * int.parse(urun.yemek_siparis_adet))} ₺',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Color(0xFF352F44),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
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
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Toplam: ${toplamTutar.toStringAsFixed(2)} ₺",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF352F44),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SepetSayfaCubit>().silTumSepet(_auth.currentUser?.email ?? "",);
                          _lottieController.reset();
                          showDialog(
                            barrierColor: Colors.white54,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Lottie.asset(
                                  'assets/lottie/delete.json',
                                  width: 200,
                                  height: 200,
                                  controller: _lottieController,
                                  onLoaded: (composition) {
                                    _lottieController
                                      ..duration = composition.duration
                                      ..forward();
                                    Future.delayed(
                                      Duration(seconds: composition.duration.inSeconds),
                                          () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Text("Sepeti Boşalt",style: TextStyle(color: Colors.white,fontSize: 20),),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Sepetiniz boş."),
            );
          }
        },
      ),
    );
  }
}
