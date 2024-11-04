import 'package:flutter/material.dart';
import 'package:jadwal_pelajaran_app/pages/jadwal_pelajaran.dart';
import 'input_field_satuan/input_field_satuan.dart';
import 'package:intl/intl.dart';
import 'tugas_mapel.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
import '../Services/tugas_mapel_services.dart';

class InputFieldJadwal extends StatefulWidget {
  final List<Mapel>? mapelList;
  const InputFieldJadwal({super.key, this.mapelList});

  @override
  InputFieldJadwalState createState() => InputFieldJadwalState();
}

class InputFieldJadwalState extends State<InputFieldJadwal> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _teachercontroller = TextEditingController();
  final TextEditingController _classcontroller = TextEditingController();
  late List<Mapel> mapelList = [];
  var _mapelService = MapelService();
  String _selectedDay = 'Senin';
  String _startTime = "9:30";
  String _endTime =
      DateFormat("HH:mm", "id_ID").format(DateTime.now()).toString();
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    // _loadMapelFromPreferences();
  }

  Future<void> _getDayFromUser(BuildContext context) async {
    List<String> daysOfWeek = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
    ];

    String? _pickerDay = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Hari'),
              SizedBox(height: 8),
              Divider(color: Colors.grey[400], thickness: 1.5),
            ],
          ),
          content: Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: daysOfWeek.map((day) {
                  bool isSelected = day == _selectedDay;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, day);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(day),
                      ),
                    ),
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

  // Future<void> _loadMapelFromPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? mapelJsonList = prefs.getStringList('mapel_list');
  //   if (mapelJsonList != null) {
  //     setState(() {
  //       mapelList = mapelJsonList
  //           .map((json) => Mapel.fromJson(jsonDecode(json)))
  //           .toList();
  //     });
  //   } else {
  //     mapelList = [];
  //   }
  // }

  // Future<void> _saveMapelToPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> mapelJsonList =
  //       mapelList.map((mapel) => jsonEncode(mapel.toJson())).toList();
  //   await prefs.setStringList('mapel_list', mapelJsonList);
  // }

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

  _validateData() async {
    if (_titlecontroller.text.isEmpty ||
        _classcontroller.text.isEmpty ||
        _teachercontroller.text.isEmpty) {
      print("ValidateData Called");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua bagian harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      var _mapel = Mapel();
      _mapel.judul = _titlecontroller.text;
      _mapel.hari = _selectedDay;
      _mapel.pengajar = _teachercontroller.text;
      _mapel.ruang = _classcontroller.text;
      _mapel.waktuMulai = _startTime;
      _mapel.waktuSelesai = _endTime;
      _mapel.warna = _selectedColor;
      var result = await _mapelService.SaveMapel(_mapel);
      if (result != null) {
        _mapel.id = result;
        setState(() {
          mapelList.add(_mapel);
        });
      }

      // setState(() {
      //   mapelList.add(result);
      // });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => JadwalPelajaranPage(mapelList: mapelList)),
      );
      _titlecontroller.clear();
      _teachercontroller.clear();
      _classcontroller.clear();
    }
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
                judul: 'Nama mapel',
                hint: 'Masukkan nama mapel',
                controller: _titlecontroller,
              ),
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
                judul: 'Pengajar',
                hint: 'Masukkan nama pengajar',
                controller: _teachercontroller,
              ),
              InputFieldSatuan(
                judul: 'Ruang',
                hint: 'Masukkan ruang',
                controller: _classcontroller,
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
                      label: 'Buat Mapel', onTap: () => _validateData()),
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
