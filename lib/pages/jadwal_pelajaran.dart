import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'input_field_jadwal.dart';
import 'dart:ui';
import 'tugas_mapel.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
import '../Services/tugas_mapel_services.dart';
import 'edit_delete/edit_delete_mapel.dart';

class JadwalPelajaranPage extends StatefulWidget {
  final List<Mapel>? mapelList;
  JadwalPelajaranPage({super.key, this.mapelList});

  @override
  _JadwalPelajaran createState() => _JadwalPelajaran();
}

class _JadwalPelajaran extends State<JadwalPelajaranPage> {
  late List<Mapel> _mapelList = <Mapel>[];
  final _mapelService = MapelService();
  int selectedDayIndex = 0;
  final List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  getAllMapelDetails() async {
    var mapels = await _mapelService.readAllMapel();
    _mapelList = <Mapel>[];
    mapels.forEach((mapel) {
      setState(() {
        var mapelModel = Mapel();
        mapelModel.id = mapel['id'];
        mapelModel.judul = mapel['judul'];
        mapelModel.hari = mapel['hari'];
        mapelModel.pengajar = mapel['pengajar'];
        mapelModel.ruang = mapel['ruang'];
        mapelModel.waktuMulai = mapel['waktuMulai'];
        mapelModel.waktuSelesai = mapel['waktuSelesai'];
        mapelModel.warna = mapel['warna'];
        _mapelList.add(mapelModel);
      });
    });
  }

  @override
  void initState() {
    getAllMapelDetails();
    super.initState();

    // _loadMapelFromPreferences();
  }

  // Future<void> _loadMapelFromPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? mapelJsonList = prefs.getStringList('mapel_list');
  //   if (mapelJsonList != null) {
  //     setState(() {
  //       _mapelList = mapelJsonList
  //           .map((json) => Mapel.fromJson(jsonDecode(json)))
  //           .toList();
  //     });
  //   }
  // }

  // Future<void> _deleteAllMapelFromPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _mapelList.clear();
  //   await prefs.remove('mapel_list');
  // }

  @override
  Widget build(BuildContext context) {
    // List untuk filter mapel per hari
    List<Mapel> filteredMapelList = _mapelList
        .where((mapel) => mapel.hari == hari[selectedDayIndex])
        .toList();
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
                children: List.generate(hari.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hari[index],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: selectedDayIndex == index
                                ? Colors.blue.shade700
                                : Colors.grey[400],
                          ),
                        ),
                        if (selectedDayIndex == index)
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
              itemCount: filteredMapelList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditMapel(
                        mapel: _mapelList[index],
                        mapelList: _mapelList,
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    color: filteredMapelList[index]
                        .convertColor(filteredMapelList[index].warna!),
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
                                    filteredMapelList[index].judul ?? '',
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
                                          filteredMapelList[index].hari ?? '',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
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
                                          '${filteredMapelList[index].waktuMulai} - ${filteredMapelList[index].waktuSelesai}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
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
                                    filteredMapelList[index].pengajar ?? '',
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
                                  filteredMapelList[index].ruang ?? '',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InputFieldJadwal()),
                );
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
