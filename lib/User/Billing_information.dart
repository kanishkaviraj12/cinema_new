import 'package:cinema_new/User/how_many_tickets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillingInformation extends StatelessWidget {
  BillingInformation({Key? key}) : super(key: key);

  final TextEditingController movieNameController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController seatsPlaceController = TextEditingController();
  final TextEditingController seatsNumberController = TextEditingController();

  Future<void> addData(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('Billing information').doc().set({
        'Movie Name': movieNameController.text,
        'Customer Name': customerNameController.text,
        'Mobile Number': int.tryParse(mobileNumberController.text) ?? 0,
        'Email': emailController.text,
        'Seats Place': seatsPlaceController.text,
        // 'Seats Number': seatsNumberController.text,
      });
      print('Data added successfully.');

      // Perform user validation
      if (validateUser()) {
        // Navigate to the next page if user is valid
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HowManyTickets()),
        );
      } else {
        // Show an error message if user is not valid
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid User'),
              content: const Text('Please enter valid user information.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  bool validateUser() {
    // Perform validation logic here
    // Return true if the user is valid, otherwise return false
    final String email = emailController.text.trim();
    final String mobileNumber = mobileNumberController.text.trim();

    return validateEmail(email) && validateMobileNumber(mobileNumber);
  }

  bool validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool validateMobileNumber(String mobileNumber) {
    final RegExp mobileNumberRegex = RegExp(r'^[0-9]{10}$');
    return mobileNumberRegex.hasMatch(mobileNumber);
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      makeInput(
                        label: "Movie Name",
                        controller: movieNameController,
                      ),
                      makeInput(
                        label: "Customer Name",
                        controller: customerNameController,
                      ),
                      makeInput(
                        label: "Mobile Number",
                        controller: mobileNumberController,
                      ),
                      makeInput(
                        label: "Email",
                        controller: emailController,
                      ),
                      makeInput(
                        label: "Seats Place",
                        controller: seatsPlaceController,
                       ),
                      // makeInput(
                      //   label: "Seats Number",
                      //   controller: seatsNumberController,
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () => addData(context),
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
          keyboardType: label == 'Mobile Number'
              ? TextInputType.number
              : TextInputType.text,
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
