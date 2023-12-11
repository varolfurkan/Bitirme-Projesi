import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_sepetim/data/entity/sepettekiler.dart';
import 'package:yemek_sepetim/data/repo/yemekler_dao_repository.dart';

class SepetSayfaCubit extends Cubit <List<Sepettekiler>>{
  SepetSayfaCubit():super(<Sepettekiler>[]);
  var yrepo = YemeklerDaoRepository();

  Future<void> sepettekiYemekleriGetir(String kullanici_adi) async{
    var liste = await yrepo.sepettekiYemekleriGetir(kullanici_adi);
    emit(liste);
  }
  Future<void> sepettenSil(int sepet_yemek_id, String kullanici_adi) async{
    await yrepo.sepettenSil(sepet_yemek_id, kullanici_adi);
    sepettekiYemekleriGetir(kullanici_adi);
  }

  Future<void> silTumSepet(String kullanici_adi) async {
    for (var urun in state) {
      await yrepo.sepettenSil(int.parse(urun.sepet_yemek_id), urun.kullanici_adi);
    }
    sepettekiYemekleriGetir(kullanici_adi);
  }

  double getToplamTutar() {
    double toplamTutar = 0.0;
    for (var urun in state) {
      toplamTutar += double.parse(urun.yemek_fiyat) * double.parse(urun.yemek_siparis_adet);
    }
    return toplamTutar;
  }


}