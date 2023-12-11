import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:yemek_sepetim/data/entity/sepettekiler.dart';
import 'package:yemek_sepetim/data/entity/yemekler.dart';
import 'package:yemek_sepetim/data/entity/yemekler_cevap.dart';

import '../entity/sepettekiler_cevap.dart';

class YemeklerDaoRepository{
  List<Yemekler> parseYemeklerCevap(String cevap){
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler;
  }

  List<Sepettekiler> parseSepettekilerCevap(String cevap) {
    try {
      var decodedJson = json.decode(cevap);
      return SepetCevap.fromJson(decodedJson).sepet_yemekler;
    } catch (e) {
      print("json dönüşümü sırasında beklenmeyen durum oluştu : $e");
      return [];
    }
  }

  Future<List<Yemekler>> yemekleriYukle({String? aramaSorgusu}) async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);
    List<Yemekler> tumYemekler = parseYemeklerCevap(cevap.data.toString());

    if (aramaSorgusu != null && aramaSorgusu.isNotEmpty) {
      // Arama sorgusuna göre filtreleme yap
      tumYemekler = tumYemekler.where((yemek) =>
          yemek.yemek_adi.toLowerCase().contains(aramaSorgusu.toLowerCase()))
          .toList();
    }

    return tumYemekler;
  }

  Future<void> sepeteEkle(String yemek_adi, String yemek_resim_adi, int yemek_fiyat, int yemek_siparis_adet, String kullanici_adi) async{
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var veri = {
      "yemek_adi" : yemek_adi,
      "yemek_resim_adi" : yemek_resim_adi,
      "yemek_fiyat" : yemek_fiyat,
      "yemek_siparis_adet" : yemek_siparis_adet,
      "kullanici_adi" : kullanici_adi,
    };
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("Sepete eklendi : ${cevap.data.toString()}");
  }

  Future<List<Sepettekiler>> sepettekiYemekleriGetir(String kullanici_adi) async{
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    var veri = {"kullanici_adi":kullanici_adi};
    var cevap = await Dio().post(url,data: FormData.fromMap(veri));
    return parseSepettekilerCevap(cevap.data.toString());
  }

  Future<void> sepettenSil(int sepet_yemek_id, String kullanici_adi) async{
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var veri = {
      "sepet_yemek_id": sepet_yemek_id,
      "kullanici_adi" : kullanici_adi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("Sepetten silindi : ${cevap.data.toString()}");
  }

  Future<void> silTumSepet(String kullanici_adi) async {
  var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
  var veri = {
  "kullanici_adi" : kullanici_adi};
  var cevap = await Dio().post(url, data: FormData.fromMap(veri));
  print("Tüm sepet silindi : ${cevap.data.toString()}");

  }


}