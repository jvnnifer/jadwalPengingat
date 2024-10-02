import 'package:flutter/material.dart';
import 'input_field_satuan/input_field_satuan.dart';
import 'package:intl/intl.dart';

class InputFieldJadwal extends StatefulWidget {
  const InputFieldJadwal({Key? key}) : super(key: key);

  @override
  InputFieldJadwalState createState() => InputFieldJadwalState();
}

class InputFieldJadwalState extends State<InputFieldJadwal> {
  DateTime _selectedDate = DateTime.now();
  String _selectedDay = 'Pilih hari';
  String _startTime = "9:30";
  String _endTime = DateFormat("hh:mm").format(DateTime.now()).toString();

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

  Future<void> _getDayFromUser(BuildContext context) async {
    List<String> daysOfWeek = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];

    String? _pickerDay = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Hari'),
          content: Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: daysOfWeek.map((day) {
                  return ListTile(
                    title: Text(day),
                    onTap: () {
                      Navigator.pop(context, day);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    if (_pickerDay != null) {
      setState(() {
        _selectedDay = _pickerDay;
      });
    }
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

  int _selectedColor = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Mata Pelajaran',
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
                  judul: 'Nama mapel', hint: 'Masukkan nama mapel'),
              // Untuk tambah tanggal di add tugas
              // InputFieldSatuan(
              //   judul: 'Tanggal',
              //   hint: DateFormat.yMd().format(_selectedDate),
              //   widget: IconButton(
              //     onPressed: () => _getDateFromUser(context),
              //     icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
              //   ),
              // ),
              InputFieldSatuan(
                judul: 'Hari',
                hint: _selectedDay,
                widget: IconButton(
                  onPressed: () => _getDayFromUser(context),
                  icon: Icon(Icons.calendar_today, color: Colors.grey),
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
                  judul: 'Pengajar', hint: 'Masukkan nama pengajar'),
              InputFieldSatuan(judul: 'Ruang', hint: 'Masukkan ruang'),
              Text(
                'Pilih Warna',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  CreateButton(label: 'Buat Mapel', onTap: () => null),
                ],
              )
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
