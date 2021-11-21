import 'package:cloud_firestore/cloud_firestore.dart';

class Mess {
  const Mess({
    required this.id,
    required this.content,
    required this.UID,
    required this.created,
    required this.sort,
    required this.writer,
    required this.receiver,
  });
  final String content;
  final String id;
  final String writer;
  final String UID;
  final Timestamp created;
  final String sort;
  final String receiver;
}
