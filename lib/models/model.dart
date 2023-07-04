import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String? id;
  final String title;
  final String director;
  final int year;
  final String genre;
  final String duration;
  final int rating;
  final String synopsis;

  Movie({
    this.id,
    required this.title,
    required this.director,
    required this.year,
    //required this.poster,
    required this.genre,
    required this.duration,
    required this.rating,
    required this.synopsis,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'director': director,
      'year': year,
      'genre': genre,
      'duration': duration,
      'rating': rating,
      'synopsis': synopsis,
    };
  }

  factory Movie.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return Movie(
      id: snapshot.id,
      title: data?['title'] ?? '',
      director: data?['director'] ?? '',
      year: data?['year'] ?? 0,
      genre: data?['genre'] ?? '',
      duration: data?['duration'] ?? '',
      rating: data?['rating'] ?? 0,
      synopsis: data?['synopsis'] ?? '',
    );
  }
}
