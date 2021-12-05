import 'package:flutter/foundation.dart';

class Event{
  const Event({required this.userid,required this.date,required this.hour,required this.min,required this.title,required this.contents});
  final String userid;
  final String date;
  final int hour;
  final int min;
  final String title;
  final String contents;
 // final String receiver_email;
}