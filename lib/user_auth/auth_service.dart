import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:yemek_sepetim/toast/toast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password,);
    } on FirebaseAuthException catch (e){
      if (e.code == "email-already-in-use") {
        showToast(message: "Email adresi zaten kullanılıyor.");
      } else {
        showToast(message: "Bir hata oluştu ${e.code}");
      }
    }
    return null;
  }
  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch (e){
      if (e.code == "user-not-found" || e.code == "invalid-password") {
        showToast(message: "Email ya da şifreniz yalnış");
      }
      else {
        showToast(message: "Bir hata oluştu ${e.code}");
      }
    }
    return null;
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
