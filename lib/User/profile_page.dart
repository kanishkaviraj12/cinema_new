import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

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
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement logout functionality
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 60.0,
              backgroundImage: imageUrl.isNotEmpty
                  ? FileImage(File(imageUrl)) as ImageProvider<Object>?
                  : NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/popcornauth-ac9bf.appspot.com/o/uploads%2FIMG_20220407_002740.jpg?alt=media&token=d8e7265a-d69c-43da-b4b3-1f686c1810e9'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Change Image'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: $name'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _editProfile,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email: $email'),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _editProfile,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Booking History',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
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
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Favourite Movies',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
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
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Payment Information',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement preferences and settings functionality
              },
              child: Text('Preferences and Settings'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement help and support functionality
              },
              child: Text('Help and Support'),
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _deleteAccount,
              child: Text('Delete Account'),
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

  EditProfilePopup({required this.name, required this.email});

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
      title: Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: Text('Save'),
        ),
      ],
    );
  }
}
