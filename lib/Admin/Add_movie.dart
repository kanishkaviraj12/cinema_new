import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/model.dart';
import 'directpage.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late TextEditingController _titleController;
  late TextEditingController _directorController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _directorController = TextEditingController();
    _yearController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _createMovie() {
    final String title = _titleController.text;
    final String director = _directorController.text;
    final int year = int.parse(_yearController.text);

    final newMovie = Movie(
      title: title,
      director: director,
      year: year,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference moviesCollection = firestore.collection('movies');

    moviesCollection.add(newMovie.toMap()).then((docRef) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie created successfully')),
      );
      _clearFields();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create movie: $error')),
      );
    });
  }

  void _updateMovie() {
    final String title = _titleController.text;
    final String director = _directorController.text;
    final int year = int.parse(_yearController.text);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference moviesCollection = firestore.collection('movies');

    moviesCollection.where('title', isEqualTo: title).get().then((snapshot) {
      if (snapshot.size == 1) {
        final movieDoc = snapshot.docs.first;
        final updatedMovie = Movie(
          title: title,
          director: director,
          year: year,
          id: movieDoc.id,
        );

        movieDoc.reference.update(updatedMovie.toMap()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Movie updated successfully')),
          );
          _clearFields();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update movie: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movie not found')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update movie: $error')),
      );
    });
  }

  void _deleteMovie() {
    final String title = _titleController.text;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference moviesCollection = firestore.collection('movies');

    moviesCollection
        .where('title', isEqualTo: title)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size == 1) {
        final movieDoc = snapshot.docs.first;

        movieDoc.reference.delete().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Movie deleted successfully')),
          );
          _clearFields();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete movie: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Movie not found')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete movie: $error')),
      );
    });
  }

  void _clearFields() {
    _titleController.clear();
    _directorController.clear();
    _yearController.clear();
  }

  void _navigateToMovieDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Movie',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(labelText: 'Director'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _createMovie,
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: _updateMovie,
                    child: const Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteMovie,
                    child: const Text('Delete'),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Movies List',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('movies').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Movie> movies = snapshot.data!.docs
                      .map((doc) => Movie.fromSnapshot(doc))
                      .toList();

                  if (movies.isEmpty) {
                    return const Center(
                      child: Text('No movies found.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: movies.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Movie movie = movies[index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text(movie.director),
                        onTap: () => _navigateToMovieDetails(movie),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
