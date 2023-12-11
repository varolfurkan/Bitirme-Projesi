import 'package:yemek_sepetim/data/entity/sepettekiler.dart';

class SepetCevap{
  List<Sepettekiler> sepet_yemekler;
  int success;
  SepetCevap({
    required this.sepet_yemekler,
    required this.success,
  });

  factory SepetCevap.fromJson(Map<String,dynamic> json){
    int success = json["success"] as int;
    var jsonArray = json["sepet_yemekler"] as List;
    List<Sepettekiler> sepet_yemekler = jsonArray.map((jsonArrayNesnesi) =>
        Sepettekiler.fromJson(jsonArrayNesnesi)).toList();
    return SepetCevap(sepet_yemekler: sepet_yemekler, success: success);
  }
}