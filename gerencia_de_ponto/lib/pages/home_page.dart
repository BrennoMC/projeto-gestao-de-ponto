import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencia_de_ponto/components/my_appbar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

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
                                suffixIcon: Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Nome Colaborador',
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
                      'Último registro: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                  ),
                  DateInput(),
                  TimePickerButton(),
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
                        // acho que n sou eu que faço
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
                        // acho que n sou eu que faço
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
  const DateInput({Key? key}) : super(key: key);

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Selecione uma data',
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              inputFormatters: [
                DateInputFormatter(),
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          Align(
            alignment: Alignment.topCenter, //tentei deixar centralizado aqui mas n vai man
            child: IconButton(
              onPressed: _presentDatePicker,
              icon: Icon(Icons.calendar_month, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}



class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    if (newText.length == 2) {
      return TextEditingValue(
        text: '$newText/',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    } else if (newText.length == 5) {
      return TextEditingValue(
        text: '$newText/',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }
    return newValue;
  }
}

class TimePickerButton extends StatefulWidget {
  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ).then((pickedTime) {
      if (pickedTime == null) return;
      setState(() {
        _selectedTime = pickedTime;
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
                _selectedTime.hour,
                _selectedTime.minute,
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