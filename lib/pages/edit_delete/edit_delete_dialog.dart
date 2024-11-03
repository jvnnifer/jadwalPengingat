import 'package:flutter/material.dart';
import '../tugas_mapel.dart';
import '../../Services/tugas_mapel_services.dart';
import '../input_field_satuan/input_field_satuan.dart';

class EditMapel extends StatefulWidget {
  final Mapel mapel;
  final List<Mapel> mapelList;
  const EditMapel({super.key, required this.mapelList, required this.mapel});

  @override
  State<EditMapel> createState() => _EditMapelState();
}

class _EditMapelState extends State<EditMapel> {
  var _mapelTitleController = TextEditingController();
  var _mapelTeacherController = TextEditingController();
  var _mapelClassController = TextEditingController();
  var _mapelService = MapelService();
  late String _selectedDay;
  late String _startTime;
  late String _endTime;

  void initState() {
    setState(() {
      _mapelTitleController.text = widget.mapel.judul ?? '';
      _mapelTeacherController.text = widget.mapel.pengajar ?? '';
      _mapelClassController.text = widget.mapel.ruang ?? '';
      _selectedDay = widget.mapel.hari ?? '';
      _startTime = widget.mapel.waktuMulai ?? '';
      _endTime = widget.mapel.waktuSelesai ?? '';
    });
  }

  // String _startTime = "9:30";
  // String _endTime =
  //     DateFormat("HH:mm", "id_ID").format(DateTime.now()).toString();
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

  _deleteFormDialog(BuildContext context, mapelId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Yakin untuk menghapus?',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    var result = await _mapelService.deleteMapel(mapelId);
                    if (result != null) {
                      int index = widget.mapelList
                          .indexWhere((item) => item.id == mapelId);
                      if (index != -1) {
                        setState(() {
                          widget.mapelList.removeAt(index);
                        });
                      }
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mapel sudah terhapus'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  _validateData() async {
    if (_mapelTitleController.text.isEmpty ||
        _mapelClassController.text.isEmpty ||
        _mapelTeacherController.text.isEmpty) {
      print("ValidateData Called");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua bagian harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      var _mapel = Mapel();
      _mapel.id = widget.mapel.id;
      _mapel.judul = _mapelTitleController.text;
      _mapel.hari = _selectedDay;
      _mapel.pengajar = _mapelTeacherController.text;
      _mapel.ruang = _mapelClassController.text;
      _mapel.waktuMulai = _startTime;
      _mapel.waktuSelesai = _endTime;
      _mapel.warna = widget.mapel.warna;
      var result = await _mapelService.updateMapel(_mapel);

      int index = widget.mapelList.indexWhere((item) => item.id == _mapel.id);
      if (index != -1) {
        setState(() {
          widget.mapelList[index] = _mapel;
        });
      }

      Navigator.pop(context, result);
      _mapelTitleController.clear();
      _mapelTeacherController.clear();
      _mapelClassController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      _deleteFormDialog(
                        context,
                        widget.mapel.id,
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.red, size: 30),
                  ),
                ],
              ),
              Text('Judul', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _mapelTitleController,
                decoration: InputDecoration(
                    hintText: 'Masukkan judul',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              InputFieldSatuan(
                judul: 'Hari',
                hint: _selectedDay,
                widget: IconButton(
                  onPressed: () => _getDayFromUser(context),
                  icon: Icon(Icons.calendar_today, color: Colors.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldSatuan(
                          judul: 'Waktu Mulai',
                          hint: _startTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: true);
                            },
                            icon: Icon(Icons.access_time_rounded,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldSatuan(
                          judul: 'Waktu Selesai',
                          hint: _endTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: false);
                            },
                            icon: Icon(Icons.access_time_rounded,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text('Pengajar', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _mapelTeacherController,
                decoration: InputDecoration(
                    hintText: 'Masukkan pengajar',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              Text('Ruang', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _mapelClassController,
                decoration: InputDecoration(
                    hintText: 'Masukkan ruang',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              EditButton(
                onPressed: _validateData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final VoidCallback onPressed;
  const EditButton({Key? key, required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: Text(
          "Edit",
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
