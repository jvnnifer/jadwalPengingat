// Halaman untuk tampilan mingguan
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'MonthViewPage.dart'; // Ensure you have this file

class WeekViewPage extends StatefulWidget {
  @override
  _WeekViewPageState createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage> {
  DateTime selectedDate = DateTime.now(); // Menyimpan tanggal yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'month_view') {
                Navigator.pop(context); // Go back to MonthViewPage
              } else if (value == 'week_view') {
                // If week view is selected, do nothing
                // or handle accordingly
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'month_view',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Month View'),
                      Icon(Icons.calendar_today, color: Colors.purple),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'week_view',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Week View'),
                      Icon(Icons.calendar_view_week, color: Colors.purple),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SfCalendar(
        view: CalendarView.week,
        // Tampilkan kalender dengan tampilan mingguan
        firstDayOfWeek: 1,
        initialDisplayDate: selectedDate,
        todayHighlightColor: Colors.purple,
        // Ganti warna bulatan tanggal hari ini
        // showNavigationArrow: true,
        // Panah navigasi
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell && calendarTapDetails.date != null) {
            setState(() {
              selectedDate = calendarTapDetails.date!;
            });
          }
        },
      ),
    );
  }

        // weekCellBuilder: (BuildContext context, WeekCellDetails details) {
        //   bool isSelected = selectedDate.isAtSameMomentAs(details.date);
        //   return Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: isSelected ? Colors.lightBlue : Colors.transparent,
        //     ),
        //     child: Center(
        //       child: Text(
        //         details.date.day.toString(),
        //         style: TextStyle(color: Colors.black),
        //       ),
        //     ),
        //   );
        // },

  }




// List<Appointment> getAppointments() {
//   List<Appointment> meetings = <Appointment>[];
//   final DateTime today = DateTime.now();
//   final DateTime startTime =
//   DateTime(today.year, today.month, today.day, 9, 0, 0);
//   final DateTime endTime = startTime.add(Duration(hours: 2));
//
//   meetings.add(Appointment(
//     startTime: startTime,
//     endTime: endTime,
//     subject: 'Conference',
//     color: Colors.blue,
//   ));
//   return meetings;
// }
//
// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }

// // Halaman untuk membuat acara dan pengingat
// class CreateEventPage extends StatelessWidget {
//   final DateTime selectedDate;
//
//   CreateEventPage(this.selectedDate);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Buat Acara'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Buat Acara untuk ${selectedDate.toLocal()}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Nama Acara',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Aksi untuk menyimpan acara
//               },
//               child: Text('Simpan Acara'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
