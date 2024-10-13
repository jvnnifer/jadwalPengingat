import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'WeekViewPage.dart';
import 'kalender.dart';
import 'tugas_mapel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MonthViewPage extends StatefulWidget {
  final bool showAppBar;
  final List<Tugas>? tugasList;
  MonthViewPage({this.showAppBar = true, this.tugasList});

  @override
  State<MonthViewPage> createState() => _MonthViewPageState();
}

class _MonthViewPageState extends State<MonthViewPage> {
  List<DateTime> selectedDates = [];
  DateTime selectedDate = DateTime.now();
  late List<Tugas> _tugasList;

  @override
  void initState() {
    super.initState();
    _tugasList = widget.tugasList ?? [];
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text('Month'),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'week_view') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeekViewPage(),
                        ),
                      );
                    } else if (value == 'month_view') {
                      Navigator.pop(context);
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
                            Icon(Icons.calendar_view_week,
                                color: Colors.purple),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                dataSource:
                    MeetingDataSource(getAppointmentsFromTugas(_tugasList)),
                selectionDecoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.transparent, width: 0), // No border
                ),
                initialDisplayDate: selectedDate,
                monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  showAgenda: true,
                ),
                onTap: (details) {
                  if (details.targetElement == CalendarElement.calendarCell &&
                      details.date != null) {
                    DateTime selectedDate = details.date!;
                    setState(() {
                      if (selectedDates.isNotEmpty) {
                        selectedDates.clear();
                      }
                      selectedDates.add(selectedDate);
                    });
                  }
                },
                monthCellBuilder:
                    (BuildContext context, MonthCellDetails details) {
                  bool isSelected = selectedDates.contains(details.date);
                  bool isToday = details.date.year == DateTime.now().year &&
                      details.date.month == DateTime.now().month &&
                      details.date.day == DateTime.now().day;
                  int currentMonth = details
                      .visibleDates[details.visibleDates.length ~/ 2].month;
                  bool isCurrentMonth = details.date.month == currentMonth;
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.lightBlue
                          : (isToday
                              ? Colors.purple
                              : Colors
                                  .transparent), // pakai warna ungu untuk hari ini
                    ),
                    child: Center(
                      child: Text(
                        details.date.day.toString(),
                        style: TextStyle(
                          color: isSelected || isToday
                              ? Colors.white
                              : (isCurrentMonth ? Colors.black : Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
