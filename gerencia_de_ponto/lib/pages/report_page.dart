import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import '../components/my_appbar.dart';
import '../components/my_button.dart' as component;
import '../main.dart';

class ReportPage extends StatefulWidget {
  ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController matriculaController = TextEditingController();
  DateTime? selectedMonth;
  final List<Map<String, dynamic>> userRecords = [];

  void salvarMatricula(String matricula) {
    setState(() {
      matriculaController.text = matricula;
    });
  }

  void gerarRelatorio() async {
    if (selectedMonth != null && matriculaController.text.isNotEmpty) {
      DateTime startOfMonth = DateTime(selectedMonth!.year, selectedMonth!.month, 1);
      DateTime endOfMonth = DateTime(selectedMonth!.year, selectedMonth!.month + 1, 0, 23, 59, 59);

      String startOfMonthStr = startOfMonth.toIso8601String();
      String endOfMonthStr = endOfMonth.toIso8601String();

      String matricula = matriculaController.text;

      DatabaseReference ref = FirebaseDatabase.instance.ref().child('pontos');
      Query query = ref.orderByChild('timestamp').startAt(startOfMonthStr).endAt(endOfMonthStr);

      DataSnapshot snapshot = await query.get();

      List<Map<String, dynamic>> records = [];
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        data.forEach((key, value) {
          if (value['idMatricula'] == matricula) {
            records.add({
              'nome': value['nome'],
              'timestamp': value['timestamp'],
              'userId': value['userId'],
            });
          }
        });
      }

      setState(() {
        userRecords.clear();
        userRecords.addAll(records);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(),
      backgroundColor: ColorConstants.backgroundScreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 300,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 55, vertical: 12),
                child: const Text(
                  'RELATÓRIO MENSAL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1C3D),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        final selected = await showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        if (selected != null) {
                          setState(() {
                            selectedMonth = selected;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: ColorConstants.inputSecondary,
                        minimumSize: Size(120, 48),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Período",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFFFFFFF),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: matriculaController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorConstants.inputSecondary,
                            hintText: 'Matrícula',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.add, color: Color(0xFFFFFFFF)),
                              onPressed: () {
                                salvarMatricula(matriculaController.text);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: component.MyButton(
                      onTap: gerarRelatorio,
                      fontSize: 14,
                      sizedWidth: 100,
                      sizedHeight: 45,
                      text: "BUSCAR",
                      backgroundColor: ColorConstants.inputLogin,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              if (userRecords.isNotEmpty)
                ...userRecords.map((record) => ListTile(
                  title: Text(record['nome']),
                  subtitle: Text(record['timestamp']),
                )),
            ]
          ),
        ),
      ),
    );
  }
}
