import 'package:cloud_firestore/cloud_firestore.dart';

class Music {
  const Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
    required this.genre,
  });
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String songUrl;
  final String genre;
}
