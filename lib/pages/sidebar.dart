import 'package:flutter/material.dart';
import 'package:jadwal_pelajaran_app/pages/home_page.dart';
import 'jadwal_pelajaran.dart';

class SideBar extends StatelessWidget {
  final String activePage;

  const SideBar({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                MaterialPageRoute(builder: (context) => JadwalPelajaranPage()),
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
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              'Kalender',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            tileColor: activePage == 'calendar' ? Colors.grey[300] : null,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
