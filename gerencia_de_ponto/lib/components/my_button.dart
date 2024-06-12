import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencia_de_ponto/main.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final double sizedWidth;
  final double sizedHeight;
  final double fontSize;
  final String text;
  final Color backgroundColor;

  const MyButton({
    super.key,
    required this.onTap,
    required this.sizedWidth,
    required this.sizedHeight,
    required this.fontSize,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizedWidth,
      height: sizedHeight,

      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: backgroundColor,
          padding: EdgeInsets.all(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),

    );
  }
}
