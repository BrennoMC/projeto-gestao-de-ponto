import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencia_de_ponto/components/my_appbar.dart';
import 'package:gerencia_de_ponto/pages/report_page.dart' as report;
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerencia_de_ponto/blocs/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? nomeColaborador;
  String? ultimoRegistro;
  bool isLoading = false;

  Future<Map<String, dynamic>?> searchByMatricula(String matricula) async {
    final databaseRef = FirebaseDatabase.instance.ref().child("pontos");
    final snapshot = await databaseRef.orderByChild("idMatricula").equalTo(matricula).once();
    // showToast('${snapshot.snapshot.value}');

    if (snapshot.snapshot.value != null) {
      final userKey = (snapshot.snapshot.value as Map).keys.first;

      final userData = (snapshot.snapshot.value as Map)[userKey];

      if (userData != null) {
        final ultimoRegistro = userData;

        return {
          "nome": ultimoRegistro["nome"],
          "ultimoRegistro": ultimoRegistro['timestamp']
        };
      } else {
       showToast('Erro ao buscar usuario');
      }
    }
    return null;
  }

  void _search() async {
    setState(() {
      isLoading = true;
    });
    final result = await searchByMatricula(_controller.text);
    setState(() {
      isLoading = false;
      if (result != null) {
        nomeColaborador = result["nome"];
        ultimoRegistro = result["ultimoRegistro"];
      } else {
        nomeColaborador = "Não encontrado";
        ultimoRegistro = "N/A";
      }
    });
  }

  void _registerPoint() async {
    if (_selectedDate == null || _selectedTime == null) {
      showToast("Dados faltantes: $_selectedDate, $_selectedTime");
      return;
    }

    // Obtendo o ID de matrícula do campo de texto de entrada
    final idMatricula = _controller.text;
    if (idMatricula.isEmpty) {
      showToast("ID de matrícula não fornecido");
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    final formattedTime = DateFormat('HH:mm').format(
      DateTime(
        2022,
        1,
        1,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
    );

    final databaseRef = FirebaseDatabase.instance.ref().child("pontos");
    try {
      final snapshot = await databaseRef.orderByChild("idMatricula").equalTo(idMatricula).once();

      if (snapshot.snapshot.value != null) {
        final userKey = (snapshot.snapshot.value as Map).keys.first;
        final userData = (snapshot.snapshot.value as Map)[userKey];
        final userPointsRef = FirebaseDatabase.instance.ref().child("pontos");

        showToast('$formattedDate $formattedTime');

        await userPointsRef.push().set({
          'idMatricula': idMatricula,
          'timestamp': '$formattedDate $formattedTime',
          'userId': userKey,
          'nome': userData['nome'],
        });

        showToast("Ponto registrado com sucesso para ${userData['nome']}!");
      } else {
        showToast("Usuário com ID de matrícula '$idMatricula' não encontrado");
      }
    } catch (error) {
      showToast("Erro ao registrar ponto: $error");
    }
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
                  'Número da matrícula:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1C3D),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          width: 180,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(0xFF1A1C3D),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: _controller,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search, color: Colors.white),
                                  onPressed: _search,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isLoading) CircularProgressIndicator(),
                  if (nomeColaborador != null) ...[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Nome Colaborador: $nomeColaborador',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Último registro: $ultimoRegistro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                  ),
                  DateInput(
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  TimePickerButton(
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: SizedBox(
                    height: 45,
                    child: MyButton(
                      text: 'REGISTRAR PONTO',
                      color: Color(0xFFFFAA01),
                      onPressed: () {
                        _registerPoint();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 45,
                    child: MyButton(
                      text: 'GERAR RELATÓRIO',
                      color: Color(0xFF1A1C3D),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => report.ReportPage()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateInput extends StatefulWidget {
  final Function(DateTime)? onDateSelected;

  const DateInput({Key? key, this.onDateSelected}) : super(key: key);

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
        widget.onDateSelected?.call(_selectedDate!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      width: 150,
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xFF1A1C3D),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: TextFormField(
              controller: _dateController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'DD/MM/AAAA',
                hintStyle: TextStyle(color: Colors.white),
              ),
              readOnly: true,
              onTap: _presentDatePicker,
            ),
          ),
          IconButton(
            onPressed: _presentDatePicker,
            icon: Icon(Icons.calendar_today, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class TimePickerButton extends StatefulWidget {
  final Function(TimeOfDay)? onTimeSelected;

  const TimePickerButton({Key? key, this.onTimeSelected}) : super(key: key);

  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  TimeOfDay? _selectedTime;

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) return;
      setState(() {
        _selectedTime = pickedTime;
        widget.onTimeSelected?.call(_selectedTime!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(10.0),
      width: 150,
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xFF1A1C3D),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            DateFormat('HH:mm').format(
              DateTime(
                2022, //aparentemente precisa disso pra poder pegar o formato de horário certinho
                1,
                1,
                _selectedTime?.hour ?? 0, // Usando ?. e ?? para acessar com segurança e fornecer um valor padrão
                _selectedTime?.minute ?? 0,
              ),
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: _presentTimePicker,
            icon: Icon(Icons.access_time, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const MyButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
