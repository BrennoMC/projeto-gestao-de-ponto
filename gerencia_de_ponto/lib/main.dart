import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gerencia_de_ponto/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


class ColorConstants {
  static const primaryColor = Color(0xFFFFAA01);
  static const inputLogin = Color(0xFFFFBF41);
  static const buttonColor = Color(0xFF2F48A5);
}