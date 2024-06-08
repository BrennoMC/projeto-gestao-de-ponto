import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

//componente de input
class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText; //label do input
  final bool obscureText; //esconder o que é digitado no input

  //construtor e obrigatoriedade de propriedades a serem passadas quando esse componente for chamado
  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 55, vertical: 12),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
        ),
        Container(
          //margin: EdgeInsets.symmetric(horizontal: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.inputLogin)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.inputLogin),
              ),
              filled: true,
              fillColor: ColorConstants.inputLogin,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),

      ],
    );
  }
}
