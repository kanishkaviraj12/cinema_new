import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Mafana";
  String email = "mafanafathima@gamil.com";
  String imageUrl = "";

  List<String> bookingHistory = [
    "Black Panther - 2023-05-25",
    "PS 2 - 2023-05-23",
    "Flash - 2023-05-20",
  ];

  List<String> favouriteMovies = [
    "Flash",
    "BatMan",
    "PS2",
  ];

  List<String> paymentInformation = [
    "HNB 1234",
    "Anuradhapura",
    "2312 2313 2313 2122 3333",
    "mafanafathima@gamil.com",
  ];

  @override
  void initState() {
    super.initState();
    loadImageUrl();
  }

  void loadImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('image_url') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('image_url', pickedFile.path);
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pop(context);
  }

  Future<void> _editProfile() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => EditProfilePopup(
        name: name,
        email: email,
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        name = result['name']!;
        email = result['email']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement logout functionality
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0),
            CircleAvatar(
              radius: 60.0,
              backgroundImage: imageUrl.isNotEmpty
                  ? FileImage(File(imageUrl)) as ImageProvider<Object>?
                  : const NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/popcornauth-ac9bf.appspot.com/o/uploads%2FIMG_20220407_002740.jpg?alt=media&token=d8e7265a-d69c-43da-b4b3-1f686c1810e9'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Change Image'),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: $name'),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editProfile,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email: $email'),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editProfile,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Booking History',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookingHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(bookingHistory[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Favourite Movies',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: favouriteMovies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(favouriteMovies[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Payment Information',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: paymentInformation.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(paymentInformation[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement preferences and settings functionality
              },
              child: const Text('Preferences and Settings'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement help and support functionality
              },
              child: const Text('Help and Support'),
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _deleteAccount,
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePopup extends StatefulWidget {
  final String name;
  final String email;

  const EditProfilePopup({super.key, required this.name, required this.email});

  @override
  _EditProfilePopupState createState() => _EditProfilePopupState();
}

class _EditProfilePopupState extends State<EditProfilePopup> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    String newName = _nameController.text;
    String newEmail = _emailController.text;

    Map<String, String> result = {
      'name': newName,
      'email': newEmail,
    };

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
