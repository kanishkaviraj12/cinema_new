import 'package:flutter/material.dart';

import '../models/model.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Movie Details',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('search:${movie.search}'),
            const SizedBox(height: 16.0),
            Text('Title: ${movie.title}'),
            const SizedBox(height: 8.0),
            Text('Director: ${movie.director}'),
            const SizedBox(height: 8.0),
            Text('Year: ${movie.year}'),
            const SizedBox(height: 8.0),
            Text('genre:${movie.genre}'),
            const SizedBox(height: 8.0),
            Text('duration:${movie.duration}'),
            const SizedBox(height: 8.0),
            Text('rating:${movie.rating}'),
            const SizedBox(height: 8.0),
            Text('synopsis:${movie.synopsis}'),
            

          ],
        ),
      ),
    );
  }
}
