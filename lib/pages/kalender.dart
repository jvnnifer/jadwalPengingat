import 'package:flutter/material.dart';
import 'package:jadwal_pelajaran_app/pages/sidebar.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'MonthViewPage.dart';
import 'WeekViewPage.dart';

class Kalender extends StatefulWidget {
  const Kalender({super.key});

  @override
  State<Kalender> createState() => _KalenderState();
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
