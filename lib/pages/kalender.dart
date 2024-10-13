import 'package:flutter/material.dart';
import 'package:jadwal_pelajaran_app/pages/sidebar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'MonthViewPage.dart';
import 'WeekViewPage.dart';
import 'tugas_mapel.dart';
import 'package:intl/intl.dart';

class Kalender extends StatefulWidget {
  const Kalender({super.key});

  @override
  State<Kalender> createState() => _KalenderState();
}

DateTime _convertToDateTime(String tanggal, String waktuMulai) {
  final DateTime parsedDate = DateFormat.yMd().parse(tanggal);

  final List<String> timeParts = waktuMulai.split(':');
  final int hour = int.parse(timeParts[0]); // Jam
  final int minute = int.parse(timeParts[1]); // Menit

  return DateTime(
      parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);
}

List<Appointment> getAppointmentsFromTugas(List<Tugas> tugasList) {
  List<Appointment> appointments = <Appointment>[];
  for (var tugas in tugasList) {
    DateTime startTime = _convertToDateTime(tugas.tanggal, tugas.waktuMulai);
    DateTime endTime = _convertToDateTime(tugas.tanggal, tugas.waktuSelesai);

    appointments.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: tugas.judul,
      color: tugas.warna,
    ));
  }
  return appointments;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _KalenderState extends State<Kalender> {
  String selectedMonth = ''; // mengembalikan bulan yang dipilih

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        activePage: 'Kalender',
      ),
      appBar: AppBar(
        title: Text(
          'Kalender',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: MonthViewPage(showAppBar: false), // Display MonthViewPage
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
                      value: 'month_view',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Month View',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.calendar_today, color: Colors.blue[700]),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'week_view',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Week View',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.calendar_view_week,
                              color: Colors.blue[700]),
                        ],
                      ),
                    ),
                  ],
                ).then((value) {
                  if (value == 'month_view') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonthViewPage(),
                      ),
                    );
                  } else if (value == 'week_view') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeekViewPage(),
                      ),
                    );
                  }
                });
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}
