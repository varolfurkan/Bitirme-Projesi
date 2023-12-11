import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_sepetim/ui/cubit/anasayfa_cubit.dart';
import 'package:yemek_sepetim/ui/cubit/sepet_sayfa_cubit.dart';
import 'package:yemek_sepetim/ui/cubit/yemek_detay_cubit.dart';
import 'package:yemek_sepetim/bottom_bar.dart';
import 'package:yemek_sepetim/user_auth/auth_service.dart';
import 'package:yemek_sepetim/user_auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnasayfaCubit()),
        BlocProvider(create: (context) => YemekDetayCubit()),
        BlocProvider(create: (context) => SepetSayfaCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: _auth.currentUser != null ? const BottomBar() : const KayitOlGirisYap(),
      ),
    );
  }
}
