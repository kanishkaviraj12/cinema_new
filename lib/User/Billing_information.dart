// Import necessary packages
import 'package:cinema_new/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create a class for the BillingInformation screen
class BillingInformation extends StatelessWidget {
  BillingInformation({Key? key}) : super(key: key);

  // Create TextEditingController instances for each input field
  final TextEditingController movieNameController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController seatsPlaceController = TextEditingController();
  final TextEditingController seatsNumberController = TextEditingController();

  // Function to add data to Firestore collection
  Future<void> addData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Add data to the 'Billing information' collection
      await firestore.collection('Billing information').doc().set({
        'Movie Name': movieNameController.text,
        'Customer Name': customerNameController.text,
        'Mobile Number': mobileNumberController.text,
        'Email': emailController.text,
        'Seats Place': seatsPlaceController.text,
        'Seats Number': seatsNumberController.text,
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 0,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Input fields using the makeInput method with appropriate labels and controllers
                        makeInput(
                            label: "Movie Name",
                            controller: movieNameController),
                        makeInput(
                            label: "Customer Name",
                            controller: customerNameController),
                        makeInput(
                            label: "Mobile Number",
                            controller: mobileNumberController),
                        makeInput(label: "Email", controller: emailController),
                        makeInput(
                            label: "Seats Place",
                            controller: seatsPlaceController),
                        makeInput(
                            label: "Seats Number",
                            controller: seatsNumberController),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 40,
                    onPressed:
                        addData, // Call addData function when the button is pressed
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Next",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 40,
                    onPressed: () {},
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Back",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  // Method to create input field widgets
  Widget makeInput(
      {required String label,
      required TextEditingController controller,
      bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(221, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller:
              controller, // Assign the provided controller to the TextField
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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

// Main function to run the Flutter app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MaterialApp(
    home: HomePage(), // Set BillingInformation as the home screen
  ));
}
