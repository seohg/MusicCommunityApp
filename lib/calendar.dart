import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'main.dart';
import 'model/event.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class CalendarPage extends StatefulWidget {
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<String>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentsController = TextEditingController();
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minController = TextEditingController();
  List<Event> events = [];
  late int hour;
  late int min;
  late String Today="";
  NumberFormat formatter = new NumberFormat("00");

  CalendarPageState(){
    selectedEvents = {};
  }


  List _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon:Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),

        title: Text('일정',textAlign: TextAlign.center),
        actions: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) =>
            Container(
              child: IconButton(
                icon:Icon(Icons.add),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Add Event"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                            controller: _titleController,
                            ),
                            TextFormField(
                              controller: _contentsController,
                            ),
                            TextButton(
                                onPressed: () {
                                  DatePicker.showTimePicker(context, showTitleActions: true,
                                      onChanged: (date) {
                                        print('change $date in time zone ' +
                                            date.timeZoneOffset.inHours.toString());
                                      },
                                      onConfirm: (date) {
                                        print('confirm $date');
                                        hour = date.hour;
                                        min = date.minute;
                                      },
                                      currentTime: DateTime.now());
                                },
                                child: Text(
                                  'show time picker',
                                  style: TextStyle(color: Colors.blue),
                                )
                            ),
                          ],
                        ),

                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text("Ok"),
                            onPressed: () {
                              if (!_titleController.text.isEmpty&&!_contentsController.text.isEmpty) {
                                  appState.eventadd(_titleController.text, _contentsController.text, Today, hour, min);
                              }
                              Navigator.pop(context);
                              _titleController.clear();
                              _contentsController.clear();
                              setState((){});
                              return;
                            },
                          ),
                        ],
                      ),

                  );

                },
              ),
            ),
          ),
        ],
      ),
      body:Consumer<ApplicationState>(
        builder: (context, appState, _) =>Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                  String today = focusDay.year.toString()+"-"+formatter.format(focusDay.month).toString()+"-"+formatter.format(focusDay.day).toString();
                  Today = today;
                  print(FirebaseAuth.instance.currentUser!.uid);
                  appState.loadSchedule(today);
                  events =appState.eventList;
                });
                print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },
              eventLoader: _getEventsfromDay,
              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),


            ExpansionTile(
                leading: Icon(Icons.notifications),
                title: Text("Schedule"),
                onExpansionChanged:(bool expanded){
                  setState(() {
                    String today = focusedDay.year.toString()+"-"+formatter.format(focusedDay.month).toString()+"-"+formatter.format(focusedDay.month).toString();
                    Today = today;
                    appState.loadSchedule(today);
                    events =appState.eventList;
                    //showComments = expanded;
                  });
                },
               children:

                List<Widget>.generate(appState.eventList.length, (idx) {
                  events=[];
                  events = appState.eventList;
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Text(
                          events[idx].title,
                          style:TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          events[idx].hour.toString()+":"+events[idx].min.toString(),
                          style:TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          events[idx].contents,
                          style:TextStyle(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  );
                }).toList()

            ),
          ],
        ),
    ),

    );
  }
}

