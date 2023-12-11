import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_sepetim/ui/cubit/anasayfa_cubit.dart';

class FavorilerSayfasi extends StatefulWidget {
  const FavorilerSayfasi({super.key});

  @override
  State<FavorilerSayfasi> createState() => _FavorilerSayfasiState();
}

class _FavorilerSayfasiState extends State<FavorilerSayfasi> {
  @override
  Widget build(BuildContext context) {
    var favoriUrunler = context.watch<AnasayfaCubit>().favoriUrunler;
    return ListView.builder(
      itemCount: favoriUrunler.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(favoriUrunler[index].yemek_adi),
        );
      },
    );
  }
}
