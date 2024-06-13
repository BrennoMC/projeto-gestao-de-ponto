import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:intl/intl.dart';
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
  DateTime selectedMonth = DateTime.now();
  final List<Map<String, dynamic>> userRecords = [];
  final double componentWidth = 300.0;

  void salvarMatricula(String matricula) {
    setState(() {
      matriculaController.text = matricula;
    });
  }

  void gerarRelatorio() async {
    String matricula = matriculaController.text.trim();
    DateTime? month = selectedMonth;


    DatabaseReference ref = FirebaseDatabase.instance.ref().child('pontos');
    Query query;

    if (matricula.isNotEmpty) {
      // Filtrar apenas pela matrícula, ignorando a data
      query = ref.orderByChild('idMatricula').equalTo(matricula);
    } else if (month != null) {
      // Filtrar apenas pela data, ignorando a matrícula
      DateTime startOfMonth = DateTime(month.year, month.month, 1);
      DateTime endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      String startOfMonthStr = startOfMonth.toIso8601String();
      String endOfMonthStr = endOfMonth.toIso8601String();

      query = ref.orderByChild('timestamp').startAt(startOfMonthStr).endAt(endOfMonthStr);
    } else {
      // Se nenhum filtro for especificado, retorna todos os registros
      query = ref;
    }

    DataSnapshot snapshot = await query.get();

    List<Map<String, dynamic>> records = [];
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        records.add({
          'nome': value['nome'],
          'timestamp': value['timestamp'],
          'idMatricula': value['idMatricula'],
          'userId': value['userId'],
        });
      });
    }

    setState(() {
      userRecords.clear();
      userRecords.addAll(records);
    });
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
                  width: componentWidth,
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
                Center(
                  child: Container(
                    width: componentWidth,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: ColorConstants.inputSecondary,
                        minimumSize: Size(180, 48),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Color(0xFFFFFFFF),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Voltar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: componentWidth,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        final selected = await showMonthPicker(
                          context: context,
                          initialDate: selectedMonth,
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
                        minimumSize: Size(180, 48),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFFFFFFF),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMMM yyyy').format(selectedMonth),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: componentWidth,
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
                const SizedBox(height: 10.0),
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: component.MyButton(
                      onTap: gerarRelatorio,
                      fontSize: 14,
                      sizedWidth: componentWidth,
                      sizedHeight: 45,
                      text: "BUSCAR",
                      backgroundColor: ColorConstants.inputLogin,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                    if (userRecords.isNotEmpty)
                      Center(
                        child: Column(
                          children: userRecords.map((record) => Container(
                            width: componentWidth,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorConstants.inputSecondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record['nome'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Matrícula: ${record['idMatricula']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(record['timestamp']))}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                  ],
                ),
            ),
        ),
    );
  }
}
