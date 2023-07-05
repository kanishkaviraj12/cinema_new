import 'package:cinema_new/User/Payment/Payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HowManyTickets extends StatefulWidget {
  HowManyTickets({Key? key}) : super(key: key);

  @override
  _HowManyTicketsState createState() => _HowManyTicketsState();
}

class _HowManyTicketsState extends State<HowManyTickets> {
  final TextEditingController fullTicketsController = TextEditingController();
  final TextEditingController halfTicketsController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  @override
  void dispose() {
    fullTicketsController.dispose();
    halfTicketsController.dispose();
    totalController.dispose();
    super.dispose();
  }

  int calculateTotal() {
    int fullTickets = int.tryParse(fullTicketsController.text) ?? 0;
    int halfTickets = int.tryParse(halfTicketsController.text) ?? 0;
    int total = fullTickets + halfTickets;
    return total;
  }

  Future<void> addData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('HowManyTickets').add({
        'FullTickets': fullTicketsController.text,
        'HalfTickets': halfTicketsController.text,
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Billing Information"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            AppBar().preferredSize.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (fullTicketsController.text.isEmpty ||
                      halfTicketsController.text.isEmpty) {
                    // Show SnackBar with validation error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please enter both full and half tickets.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    int total = calculateTotal();
                    totalController.text = total.toString();
                    addData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('successfully! Now you are directly Payment page'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>PaymentApp(),
                      ),
                    );
                    // Add navigation code here
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
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
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          obscureText: obscureText,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            if (label == "Full Tickets" || label == "Half Tickets") {
              int total = calculateTotal();
              controller.text = total.toString();
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
