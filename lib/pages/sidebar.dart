import 'package:flutter/material.dart';
import 'package:jadwal_pelajaran_app/pages/home_page.dart';
import 'package:jadwal_pelajaran_app/pages/kalender.dart';
import 'package:jadwal_pelajaran_app/pages/pengingat_otomatis.dart';
import 'jadwal_pelajaran.dart';
import 'tugas_mapel.dart';
import 'auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatelessWidget {
  final String activePage;
  final List<Tugas>? tugasList;

  const SideBar({
    super.key,
    required this.activePage,
    this.tugasList,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Penjadwalan & Pengingat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    'Beranda',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  tileColor: activePage == 'home' ? Colors.grey[300] : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text(
                    'Jadwal Pelajaran',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  tileColor: activePage == 'schedule' ? Colors.grey[300] : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JadwalPelajaranPage(
                                mapelList: [],
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text(
                    'Pengingat',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  tileColor: activePage == 'reminder' ? Colors.grey[300] : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PengingatOtomatisPage(
                                tugasList: tugasList,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(
                    'Kalender',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  tileColor: activePage == 'calendar' ? Colors.grey[300] : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Kalender()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Bagian Logout di bawah sendiri
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('userId');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
          ),
        ],
      ),
    );
  }
}
