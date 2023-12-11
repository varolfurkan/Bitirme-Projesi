import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:yemek_sepetim/data/entity/yemekler.dart';
import 'package:yemek_sepetim/ui/cubit/anasayfa_cubit.dart';
import 'package:yemek_sepetim/ui/cubit/yemek_detay_cubit.dart';

class YemekDetaySayfa extends StatefulWidget {
  Yemekler yemek;

  YemekDetaySayfa({
    required this.yemek,
  });

  @override
  State<YemekDetaySayfa> createState() => _YemekDetaySayfaState();
}

class _YemekDetaySayfaState extends State<YemekDetaySayfa> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _siparisAdet = 1;
  double _toplamFiyat = 0.0;
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _guncelle();
    _lottieController = AnimationController(vsync: this);
  }

  void _guncelle() {
    _toplamFiyat = _siparisAdet * double.parse(widget.yemek.yemek_fiyat);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.clear),color: Colors.white, onPressed: () {
            Navigator.pop(context);
        },
        ),
        actions: [
          IconButton(
            icon: isFavorite
                ? const Icon(Icons.favorite, color: Colors.white)
                : const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;

                if (isFavorite) {
                  context.read<AnasayfaCubit>().favoriyeEkle(widget.yemek);

                } else {
                  context.read<AnasayfaCubit>().favoridenCikar(widget.yemek);

                }
              });
            },
          ),
        ],
        centerTitle: true,
        title: const Text("Ürün Detayı",style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Image.network(
                  "http://kasimadalan.pe.hu/yemekler/resimler/${widget.yemek.yemek_resim_adi}"),
              Text(widget.yemek.yemek_adi,
                  style: const TextStyle(
                      fontSize: 35,fontWeight: FontWeight.bold, color: Color(0xFF352F44))),
              Text("${widget.yemek.yemek_fiyat} ₺",
                  style: const TextStyle(
                      fontSize: 30,fontWeight: FontWeight.bold, color: Color(0xFF352F44))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _siparisAdet > 1
                        ? () {
                            setState(() {
                              _siparisAdet--;
                              _guncelle();
                            });
                          }
                        : null,
                    icon: const Icon(Icons.indeterminate_check_box,color: Colors.deepPurpleAccent,),
                    iconSize: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _siparisAdet.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _siparisAdet++;
                        _guncelle();
                      });
                    },
                    icon: const Icon(Icons.add_box,color: Colors.deepPurpleAccent,),
                    iconSize: 50,
                  )
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 24.0,
              left: 16.0,
              child: Text(
                "Tutar: ${_toplamFiyat.toStringAsFixed(2)} ₺",
                style: const TextStyle(
                    fontSize: 23,fontWeight: FontWeight.bold, color: Color(0xFF352F44)),
              )),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                context.read<YemekDetayCubit>().sepeteEkle(
                      widget.yemek.yemek_adi,
                      widget.yemek.yemek_resim_adi,
                      int.parse(widget.yemek.yemek_fiyat),
                      _siparisAdet,
                  _auth.currentUser?.email ?? "",
                    );
                _lottieController.reset();
                showDialog(
                  barrierColor: Colors.white54,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: Lottie.asset(
                        'assets/lottie/confirmed.json',
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
                          });
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
              child: const Text(
                "Sepete Ekle",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
