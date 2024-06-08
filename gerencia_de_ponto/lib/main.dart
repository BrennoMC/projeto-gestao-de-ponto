import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gerencia_de_ponto/pages/home_page.dart';
import 'package:gerencia_de_ponto/pages/login_page.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


class ColorConstants {
  static const primaryColor = Color(0xFFFFAA01);
  static const inputLogin = Color(0xFFFFBF41);
  static const buttonColor = Color(0xFF2F48A5);
}