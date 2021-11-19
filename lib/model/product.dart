import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.contents,
    required this.likeList,
    required this.UID,
    required this.create,
    required this.update,
    required this.sort,
    required this.writer,
  });
  final String contents;
  final String id;
  final String title;
  final List likeList;
  final String writer;
  final String UID;
  final Timestamp create;
  final Timestamp update;
  final String sort;
}
