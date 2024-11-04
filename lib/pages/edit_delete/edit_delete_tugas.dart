import 'package:flutter/material.dart';
import '../tugas_mapel.dart';
import '../../Services/tugas_mapel_services.dart';
import '../input_field_satuan/input_field_satuan.dart';
import 'package:intl/intl.dart';

class EditTugas extends StatefulWidget {
  final Tugas tugas;
  final List<Tugas> tugasList;
  const EditTugas({super.key, required this.tugasList, required this.tugas});

  @override
  State<EditTugas> createState() => _EditTugasState();
}

class _EditTugasState extends State<EditTugas> {
  var _tugasTitleController = TextEditingController();
  var _tugasNoteController = TextEditingController();
  var _tugasService = TugasService();
  late DateTime _selectedDate;
  late String _startTime;
  late String _endTime;

  void initState() {
    setState(() {
      _tugasTitleController.text = widget.tugas.judul ?? '';
      _tugasNoteController.text = widget.tugas.note ?? '';
      _selectedDate = DateFormat.yMd().parse(widget.tugas.tanggal!);
      _startTime = widget.tugas.waktuMulai ?? '';
      _endTime = widget.tugas.waktuSelesai ?? '';
    });
  }

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

  // String _startTime = "9:30";
  // String _endTime =
  //     DateFormat("HH:mm", "id_ID").format(DateTime.now()).toString();

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

  _deleteFormDialog(BuildContext context, tugasId) {
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
                    var result = await _tugasService.deleteTugas(tugasId);
                    if (result != null) {
                      int index = widget.tugasList
                          .indexWhere((item) => item.id == tugasId);
                      if (index != -1) {
                        setState(() {
                          widget.tugasList.removeAt(index);
                        });
                      }
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('tugas sudah terhapus'),
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
    if (_tugasTitleController.text.isEmpty ||
        _tugasNoteController.text.isEmpty) {
      print("ValidateData Called");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua bagian harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      var _tugas = Tugas();
      _tugas.id = widget.tugas.id;
      _tugas.judul = _tugasTitleController.text;
      _tugas.note = _tugasNoteController.text;
      _tugas.tanggal = DateFormat.yMd().format(_selectedDate);
      _tugas.waktuMulai = _startTime;
      _tugas.waktuSelesai = _endTime;
      _tugas.warna = widget.tugas.warna;
      var result = await _tugasService.UpdateTugas(_tugas);

      int index = widget.tugasList.indexWhere((item) => item.id == _tugas.id);
      if (index != -1) {
        setState(() {
          widget.tugasList[index] = _tugas;
        });
      }

      Navigator.pop(context, result);
      _tugasTitleController.clear();
      _tugasNoteController.clear();
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
                        widget.tugas.id,
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.red, size: 30),
                  ),
                ],
              ),
              Text('Judul', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _tugasTitleController,
                decoration: InputDecoration(
                    hintText: 'Masukkan judul',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              Text('Note', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _tugasNoteController,
                decoration: InputDecoration(
                    hintText: 'Masukkan Note',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              InputFieldSatuan(
                judul: 'Tanggal',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(context),
                  icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
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
