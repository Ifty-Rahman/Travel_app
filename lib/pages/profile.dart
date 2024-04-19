import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency/data/constants.dart';
import 'package:travel_agency/data/user_image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentuser = FirebaseAuth.instance.currentUser!;

  File? _selectedImage;

  Future<void> uploadImageToFirebaseStorage(File imageFile) async {
    final userEmail = currentuser.email!;
    final fileName = '$userEmail.jpg';
    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref('profile_images')
        .child(fileName);

    try {
      await firebaseStorageRef.putFile(
        imageFile,
        firebase_storage.SettableMetadata(
          cacheControl: 'max-age=0',
        ),
      );
      final imageUrl = await firebaseStorageRef.getDownloadURL();
      print(imageUrl);

      // You can now use the imageUrl as needed (e.g., save it in Firestore)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image'),
          duration: Duration(seconds: 2),
        ),
      );
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        backgroundColor: kBackgroundColor,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          UserImagePicker(
            onPickImage: (pickedImage) {
              _selectedImage = pickedImage;
            },
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_selectedImage != null) {
                    uploadImageToFirebaseStorage(_selectedImage!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select an image first'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            currentuser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
