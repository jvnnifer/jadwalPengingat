import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'input_field_jadwal.dart';
import 'dart:ui';
import 'tugas_mapel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JadwalPelajaranPage extends StatefulWidget {
  final List<Mapel>? mapelList;
  JadwalPelajaranPage({super.key, this.mapelList});

  @override
  _JadwalPelajaran createState() => _JadwalPelajaran();
}

class _JadwalPelajaran extends State<JadwalPelajaranPage> {
  late List<Mapel> _mapelList;
  int selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _mapelList = widget.mapelList ?? [];
    _loadMapelFromPreferences();
  }

  Future<void> _loadMapelFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? mapelJsonList = prefs.getStringList('mapel_list');
    if (mapelJsonList != null) {
      setState(() {
        _mapelList = mapelJsonList
            .map((json) => Mapel.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> _deleteAllMapelFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mapelList.clear();
    await prefs.remove('mapel_list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        activePage: 'schedule',
      ),
      appBar: AppBar(
        title: Text('Jadwal Pelajaran'),
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
                'Hari',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  String day;
                  switch (index) {
                    case 0:
                      day = 'Senin';
                      break;
                    case 1:
                      day = 'Selasa';
                      break;
                    case 2:
                      day = 'Rabu';
                      break;
                    case 3:
                      day = 'Kamis';
                      break;
                    case 4:
                      day = 'Jumat';
                      break;
                    default:
                      day = '';
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex =
                            index; // Set indeks hari yang dipilih
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: selectedDayIndex == index
                                ? Colors.blue.shade700
                                : Colors.grey[400],
                          ),
                        ),
                        if (selectedDayIndex ==
                            index) // Tanda jika hari dipilih
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            height: 3,
                            width: 50,
                            color: Colors.blue.shade700,
                          ),
                      ],
                    ),
                  );
                }).map((item) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: item,
                  );
                }).toList(),
              ),
            ),
          ),
          // Card jadwal pelajaran
          Expanded(
            child: ListView.builder(
              itemCount: _mapelList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: _mapelList[index].warna,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _mapelList[index].judul,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        _mapelList[index].hari,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  // Bagian Kanan
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          color: Colors.white),
                                      SizedBox(
                                          width:
                                              8), // Jarak antara ikon dan teks
                                      Text(
                                        '${_mapelList[index].waktuMulai} - ${_mapelList[index].waktuSelesai}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _mapelList[index].pengajar,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1.5,
                          height: 100,
                          color: Colors.white,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _mapelList[index].ruang,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
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
                      value: 'add_subject',
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
                      value: 'edit_subject',
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
                      value: 'delete_subject',
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
                  if (value == 'add_subject') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputFieldJadwal()),
                    );
                  } else if (value == 'edit_subject') {
                    // Edit pelajaran
                  } else if (value == 'delete_subject') {
                    _deleteAllMapelFromPreferences();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JadwalPelajaranPage()),
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
