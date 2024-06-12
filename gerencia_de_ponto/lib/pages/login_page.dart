import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencia_de_ponto/blocs/auth_service.dart';
import 'package:gerencia_de_ponto/components/my_button.dart' as components;
import 'package:gerencia_de_ponto/pages/home_page.dart' as home;
import '../components/my_textfield.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;

  //obter email e senha do usuario
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //função para logar
  void signInUser(BuildContext context) async {
    final message = await AuthService().login(
      email: usernameController.text,
      password: passwordController.text
    );

    print("message = $message");

    if(message!.contains('Success')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => home.HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(50.0, 80.0, 50.0, 25.0),
                child: const Image(
                  image: AssetImage('lib/images/logo_puc.png'),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(50.0, 0, 50.0, 25.0),
                child: const Image(
                  image: AssetImage('lib/images/title_app.png'),
                ),
              ),

               MyTextfield(
                controller: usernameController,
                hintText: 'Usuário',
                obscureText: false,
              ),

              const SizedBox(height: 20.0),

               MyTextfield(
                controller: passwordController,
                hintText: 'Senha',
                obscureText: true,
              ),

              const SizedBox(height: 10.0),

              /*
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Esqueceu a senha?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              */


              const SizedBox(height: 30.0),
              components.MyButton(
                onTap: () => signInUser(context),
                fontSize: 20,
                sizedWidth: 200,
                sizedHeight: 35,
                text: "Entrar",
                backgroundColor: ColorConstants.buttonColor,
              ),
            ],
          ),
        ),


        ),
    );
  }
}
