import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class JadwalPelajaranPage extends StatefulWidget {
  @override
  _JadwalPelajaran createState() => _JadwalPelajaran();
}

class _JadwalPelajaran extends State<JadwalPelajaranPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(activePage: 'schedule'),
      appBar: AppBar(
        title: Text('Jadwal Pelajaran'),
      ),
      body: Column(
        children: [
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
        ],
      ),
    );
  }
}
