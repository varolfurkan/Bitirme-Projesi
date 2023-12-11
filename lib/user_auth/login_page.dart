import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yemek_sepetim/bottom_bar.dart';
import 'package:yemek_sepetim/toast/toast.dart';
import 'package:yemek_sepetim/user_auth/auth_service.dart';

class KayitOlGirisYap extends StatefulWidget {
  const KayitOlGirisYap({Key? key}) : super(key: key);

  @override
  _KayitOlGirisYapState createState() => _KayitOlGirisYapState();
}

class _KayitOlGirisYapState extends State<KayitOlGirisYap> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  bool _obscureText = true;
  bool _isLoginMode = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFB407C),
          title: Text(
            _isLoginMode ? 'Giriş Yap' : 'Kayıt Ol',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Şifre',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                ElevatedButton(
                  onPressed: ()  async{
                      if (_isLoginMode) {
                          await _authService.signInWithEmailAndPassword(
                            context,
                            _emailController.text,
                            _passwordController.text,
                        );
                        if (_auth.currentUser != null) {
                          navigateBottomSayfa().then((_) {
                            showToast(message: "Giriş yapıldı.");
                          });
                        }
                      } else {
                          await _authService.createUserWithEmailAndPassword(
                            context,
                            _emailController.text,
                            _passwordController.text,
                        );
                        if (_auth.currentUser != null) {
                          navigateGirisSayfa().then((_){
                            showToast(message: "Kayıt başarıyla oluşturuldu.");
                          });
                        }
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Text(_isLoginMode ? 'Giriş Yap' : 'Kayıt Ol',
                    style: const TextStyle(color: Colors.white,fontSize: 20)),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                    });
                  },
                  child: Text(
                    _isLoginMode
                        ? "Hesabınız yok mu? Hemen kayıt ol"
                        : "Zaten hesabınız var mı? Hemen giriş yap",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> navigateBottomSayfa() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  const BottomBar()),
    );
  }
  Future<void> navigateGirisSayfa() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>  const KayitOlGirisYap()));

  }

}