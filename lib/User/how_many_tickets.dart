import 'package:cinema_new/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class howManyTickets extends StatelessWidget {
  howManyTickets({Key? key}) : super(key: key);

  final TextEditingController fullTicketsController = TextEditingController();
  final TextEditingController halfTicketsController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  Future<void> addData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('How Many Tickets').doc().set({
        'Full Tickets': fullTicketsController.text,
        'Half Tickets': halfTicketsController.text,
        'Total': totalController.text,
      });
      print('Data added successfully.');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How Many Tickets"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              makeInput(
                label: "Full Tickets",
                controller: fullTicketsController,
              ),
              makeInput(
                label: "Half Tickets",
                controller: halfTicketsController,
              ),
              makeInput(
                label: "Total",
                controller: totalController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  addData();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(),
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
