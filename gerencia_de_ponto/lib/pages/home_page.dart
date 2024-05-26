import 'package:flutter/material.dart';
import 'package:gerencia_de_ponto/components/my_appbar.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 40.0),
              child: const SizedBox(
                width: 352,
                height: 22,
                child: Text(
                  'REGISTRO DE PONTO MANUAL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1C3D),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: const SizedBox(
                width: 352,
                height: 22,
                child: Text(
                  'Número da Matrícula',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1C3D),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
