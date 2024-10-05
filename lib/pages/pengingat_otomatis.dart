import 'package:flutter/material.dart';
import 'package:jadwal_pelajaran_app/pages/input_field_pengingat.dart';
import 'sidebar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'tugas_mapel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'notification_service.dart';

class PengingatOtomatisPage extends StatefulWidget {
  final List<Tugas>? tugasList;

  PengingatOtomatisPage({super.key, this.tugasList});
  @override
  _PengingatOtomatis createState() => _PengingatOtomatis();
}

class _PengingatOtomatis extends State<PengingatOtomatisPage> {
  late List<Tugas> _tugasList;

  @override
  void initState() {
    super.initState();
    _tugasList = widget.tugasList ?? [];
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService.init();
    _loadTugasFromPreferences();
  }

  Future<void> _loadTugasFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tugasJsonList = prefs.getStringList('tugas_list');
    if (tugasJsonList != null) {
      setState(() {
        _tugasList = tugasJsonList
            .map((json) => Tugas.fromJson(jsonDecode(json)))
            .toList();
      });
      _scheduleAllNotifications();
    }
  }

  void _scheduleAllNotifications() {
    for (int index = 0; index < _tugasList.length; index++) {
      final DateTime scheduleTime = _convertToDateTime(
          _tugasList[index].tanggal, _tugasList[index].waktuMulai);

      // Menjadwalkan notifikasi
      NotificationService.scheduledNotification(
        index,
        'Pengingat: ${_tugasList[index].judul}',
        'Jangan lupa mengerjakan tugas!',
        scheduleTime,
      );
    }
  }

  DateTime _convertToDateTime(String tanggal, String waktuMulai) {
    final DateTime parsedDate = DateFormat.yMd().parse(tanggal);

    final List<String> timeParts = waktuMulai.split(':');
    final int hour = int.parse(timeParts[0]); // Jam
    final int minute = int.parse(timeParts[1]); // Menit

    return DateTime(
        parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);
  }

  Future<void> _deleteAllTasksFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tugasList.clear();
    await prefs.remove('tugas_list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        activePage: 'reminder',
      ),
      appBar: AppBar(
        title: Text('Pengingat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 10,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hari ini',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.blue.shade700,
                selectedTextColor: Colors.white,
                dateTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tugasList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: _tugasList[index].warna,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _tugasList[index].judul,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        '${_tugasList[index].tanggal}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        '${_tugasList[index].waktuMulai} - ${_tugasList[index].waktuSelesai}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _tugasList[index].note,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 2),
                              Icon(Icons.circle, size: 8, color: Colors.white),
                              SizedBox(height: 2),
                              Icon(Icons.circle, size: 8, color: Colors.white),
                              SizedBox(height: 2),
                              Icon(Icons.circle, size: 8, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(300.0, 600.0, 0.0, 0.0),
                  items: [
                    PopupMenuItem(
                      value: 'add_reminder',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tambah',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add, color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit_reminder',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.edit, color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete_reminder',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hapus',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.delete, color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).then((value) {
                  if (value == 'add_reminder') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputFieldPengingat()),
                    );
                  } else if (value == 'edit_reminder') {
                    // Edit pelajaran
                  } else if (value == 'delete_reminder') {
                    // Hapus pelajaran
                    _deleteAllTasksFromPreferences();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PengingatOtomatisPage()),
                    );
                  }
                });
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.blue[400],
            ),
          ),

        ],
      ),
    );
  }
}