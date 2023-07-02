import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String? id;
  final String title;
  final String director;
  final int year;

  Movie({
    this.id,
    required this.title,
    required this.director,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'director': director,
      'year': year,
    };
  }

  factory Movie.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return Movie(
      id: snapshot.id,
      title: data?['title'] ?? '',
      director: data?['director'] ?? '',
      year: data?['year'] ?? 0,
    );
  }
}
