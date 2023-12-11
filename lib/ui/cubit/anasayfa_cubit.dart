import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_sepetim/data/entity/yemekler.dart';
import 'package:yemek_sepetim/data/repo/yemekler_dao_repository.dart';

class AnasayfaCubit extends Cubit<List<Yemekler>>{
  AnasayfaCubit():super(<Yemekler>[]);
  List<Yemekler> favoriUrunler = [];
  String? get currentUserUID => FirebaseAuth.instance.currentUser?.uid;

  void favoriyeEkle(Yemekler yemek) {
    if (currentUserUID != null) {
      // Favori eklemek için kullanıcının belgesini güncelle
      // Bu örnek Firestore kullanıyor, sizin kullanmanız gereken veritabanına bağlıdır
      FirebaseFirestore.instance.collection('users').doc(currentUserUID).update({
        'favoriUrunler': FieldValue.arrayUnion([yemek.yemek_adi]),
      });
      emit([...state, yemek]);
    }
  }
  void favoridenCikar(Yemekler yemek) {
    if (currentUserUID != null) {
      // Favori çıkarmak için kullanıcının belgesini güncelle
      FirebaseFirestore.instance.collection('users').doc(currentUserUID).update({
        'favoriUrunler': FieldValue.arrayRemove([yemek.yemek_adi]),
      });
      favoriUrunler.removeWhere((element) => element.yemek_adi == yemek.yemek_adi);
      emit([...state]);
    }
  }



  var yrepo = YemeklerDaoRepository();
  Future<void> yemekleriYukle({String? aramaSorgusu}) async {
    var yemeklerListesi = await yrepo.yemekleriYukle(aramaSorgusu: aramaSorgusu);
    emit(yemeklerListesi);
  }

  void aramaYap(String aramaMetni) {
    yemekleriYukle(aramaSorgusu: aramaMetni);
  }

}