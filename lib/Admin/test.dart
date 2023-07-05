import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/model.dart';




class FirebaseDataScreen extends StatefulWidget {
  final List<Movie> movies;

  const FirebaseDataScreen({super.key, required this.movies});

  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
  late Stream<QuerySnapshot> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = FirebaseFirestore.instance.collection('movies').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final documentData = documents[index].data() as Map<String, dynamic>;
                final title = documentData['title'];
                final description = documentData['director'] ?? 'No description available';
                return ListTile(
                  title: Text(title),
                  subtitle: description != null ? Text(description) : null,
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred.'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
