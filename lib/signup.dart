import 'package:cinema_new/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController confirmPasswordController = TextEditingController();

  // Define variables to store email and password
  String email = '';
  String password = '';
  String fname = '';
  int tpnumber = 0;
  String lname = '';

  @override
  void dispose() {
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80.0),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    // Store the full name entered by the user
                    fname = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_2_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    // Store the full name entered by the user
                    lname = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_2_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    // Store the email entered by the user
                    email = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    // Store the telephone number entered by the user
                    tpnumber = int.tryParse(value) ?? 0;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Telephone Number',
                  prefixIcon: Icon(Icons.call),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    // Store the password entered by the user
                    password = value;
                  });
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.password_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.password_rounded),
                 border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30.0),
              MaterialButton(
                onPressed: () {
                  if (validateForm(context)) {
                    signUp(
                      email,
                      password,
                      fname,
                      tpnumber.toString(),
                      lname,
                    );
                  }
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the sign-in page
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateForm(BuildContext context) {
    if (fname.isEmpty ||
        lname.isEmpty ||
        email.isEmpty ||
        tpnumber.toString().length != 10 ||
        !email.contains('@') ||
        !email.endsWith('.com') ||
        password.length < 6 ||
        password != confirmPasswordController.text) {
      String errorMessage = '';
      if (fname.isEmpty) {
        errorMessage += 'Full Name is required.\n';
      }
      if (lname.isEmpty) {
        errorMessage += 'Last Name is required.\n';
      }
      if (email.isEmpty) {
        errorMessage += 'Email is required.\n';
      } else if (!email.contains('@') || !email.endsWith('.com')) {
        errorMessage += 'Invalid email format.\n';
      }
      if (tpnumber.toString().length != 10) {
        errorMessage += 'Telephone Number should have 10 digits.\n';
      }
      if (password.length < 6) {
        errorMessage += 'Password must be at least 6 characters.\n';
      }
      if (password != confirmPasswordController.text) {
        errorMessage += 'Passwords do not match.\n';
      }
      final snackBar = SnackBar(
        content: Text(errorMessage),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  void signUp(String email, String password, String fname, String tpnumber,
      String lname) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User signed up successfully
      User? user = userCredential.user;
      if (user != null) {
        if (kDebugMode) {
          print('User signed up successfully: ${user.uid}');
        }

        // Store the user's fname in Firebase Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        await firestore.collection('users').doc(user.uid).set({
          'fname': fname,
          'tpnumber': tpnumber,
          'lname': lname,
        });

        // Navigate to the billing information page
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              SignupPage: () {},
              showRegisterPage: () {},
              showRejisterPage: () {},
            ),
          ),
        );
      }
    } catch (e) {
      // Error occurred during sign-up
      if (kDebugMode) {
        print('Sign up error: $e');
      }
    }
  }
}

