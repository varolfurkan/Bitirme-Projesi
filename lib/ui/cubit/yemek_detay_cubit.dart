import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_sepetim/data/entity/sepettekiler.dart';
import 'package:yemek_sepetim/data/repo/yemekler_dao_repository.dart';

class YemekDetayCubit extends Cubit<List<Sepettekiler>> {
  YemekDetayCubit() : super(<Sepettekiler>[]);

  var yrepo = YemeklerDaoRepository();

  Future<void> sepeteEkle(
      String yemek_adi,
      String yemek_resim_adi,
      int yemek_fiyat,
      int yemek_siparis_adet,
      String kullanici_adi,
      ) async {
    // Sepetteki ürünleri getir
    var sepetUrunleri = await yrepo.sepettekiYemekleriGetir(kullanici_adi);

    // daha önce aynı ürün var mı kontrol
    var existingProduct = sepetUrunleri.firstWhereOrNull(
          (urun) => urun.yemek_adi == yemek_adi,
    );

    if (existingProduct != null) {
      await yrepo.sepettenSil(
        int.parse(existingProduct.sepet_yemek_id),
        kullanici_adi,
      );
      await yrepo.sepeteEkle(
        yemek_adi,
        yemek_resim_adi,
        yemek_fiyat,
        int.parse(existingProduct.yemek_siparis_adet )+ yemek_siparis_adet,
        // burda varsa aynı üründen adeti arttırıyoruz
        kullanici_adi,
      );
    } else {
      // ürün yoksa da yeni ürün gibi ekliyoz
      await yrepo.sepeteEkle(
        yemek_adi,
        yemek_resim_adi,
        yemek_fiyat,
        yemek_siparis_adet,
        kullanici_adi,
      );
    }


    emit(sepetUrunleri);
  }
}
