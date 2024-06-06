import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencia_de_ponto/pages/login_page.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1C3D),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40.0,
            child: Image.asset(
                'lib/images/title_app.png',
                fit: BoxFit.contain
            ),
          ),
        ],
      ),
      centerTitle: true,
      leading: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'lib/images/logo_puc.png',
            height: 40.0,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'lib/images/button_exit.png',
              height: 40.0,
            ),
          ),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}