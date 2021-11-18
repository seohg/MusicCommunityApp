import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.likeList,
    required this.UID,
    required this.create,
    required this.update,
    required this.sort,
  });
  final String description;
  final String id;
  final String name;
  final List likeList;
  final String UID;
  final Timestamp create;
  final Timestamp update;
  final String sort;
}
