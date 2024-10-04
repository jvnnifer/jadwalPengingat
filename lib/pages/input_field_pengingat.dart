import 'package:flutter/material.dart';
import 'input_field_satuan/input_field_satuan.dart';
import 'package:intl/intl.dart';
import 'tugas_mapel.dart';
import 'pengingat_otomatis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InputFieldPengingat extends StatefulWidget {
  @override
  InputFieldPengingatState createState() => InputFieldPengingatState();
}

class InputFieldPengingatState extends State<InputFieldPengingat> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = "9:30";
  String _endTime =
      DateFormat("HH:mm", "id_ID").format(DateTime.now()).toString();

  List<Tugas> tugasList = [];
  int _selectedColor = 0;

  Future<void> _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2125),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  Future<void> _saveTugasToPreferences(List<Tugas> tugasList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> tugasJsonList =
        tugasList.map((tugas) => jsonEncode(tugas.toJson())).toList();

    await prefs.setStringList('tugas_list', tugasJsonList);
  }

  _showTimePicker() async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1])),
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime != null) {
      String _formattedTime = pickedTime.format(context);

      setState(() {
        if (isStartTime) {
          _startTime = _formattedTime;
        } else {
          _endTime = _formattedTime;
        }
      });
    }
  }

  Widget _colorPallete() {
    return Column(
      children: [
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: index == 0
                      ? Colors.blue
                      : index == 1
                          ? Colors.pink
                          : index == 2
                              ? Colors.orange
                              : Colors.grey,
                  child: _selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 25)
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.pink;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  int _selectedRemind = 5;
  List<int> reminderList = [
    5,
    10,
    15,
    20,
  ];

  DateTime _convertToDateTime(String tanggal, String waktuMulai) {
    final DateTime parsedDate = DateFormat.yMd().parse(tanggal);
    final List<String> timeParts = waktuMulai.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    return DateTime(
        parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);
  }

  _validateData() async {
    if (_titlecontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua bagian harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (_convertToDateTime(
            DateFormat.yMd().format(_selectedDate), _startTime)
        .isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Waktu tugas tidak boleh di masa lalu'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Tugas newTugas = Tugas(
        judul: _titlecontroller.text,
        note: _notecontroller.text,
        tanggal: DateFormat.yMd().format(_selectedDate),
        waktuMulai: _startTime,
        waktuSelesai: _endTime,
        warna: _getColor(_selectedColor),
      );

      setState(() {
        tugasList.add(newTugas);
      });

      await _saveTugasToPreferences(tugasList);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PengingatOtomatisPage()),
      );
      _titlecontroller.clear();
      _notecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pengingat',
        ),
        backgroundColor: Colors.white70,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white70,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputFieldSatuan(
                judul: 'Nama tugas',
                hint: 'Masukkan nama tugas',
                controller: _titlecontroller,
              ),
              InputFieldSatuan(
                judul: 'Note',
                hint: 'Masukkan note',
                controller: _notecontroller,
              ),
              // Untuk tambah tanggal di add tugas
              InputFieldSatuan(
                judul: 'Tanggal',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(context),
                  icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InputFieldSatuan(
                      judul: 'Waktu Mulai',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon:
                            Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InputFieldSatuan(
                      judul: 'Waktu Selesai',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon:
                            Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              InputFieldSatuan(
                judul: 'Ingatkan saya',
                hint: "$_selectedRemind menit sebelum",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items:
                      reminderList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                        value: value.toString(), child: Text(value.toString()));
                  }).toList(),
                ),
              ),
              Text(
                'Pilih Warna',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  CreateButton(
                      label: 'Buat Pengingat', onTap: () => _validateData()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const CreateButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
