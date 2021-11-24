import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  const Comment({
    required this.commentid,
    required this.docid,
    required this.userid,
    required this.username,
    required this.comment,
    required this.time,
  });
  final String commentid;
  final String docid;
  final String userid;
  final String username;
  final String comment;
  final Timestamp time;
}
