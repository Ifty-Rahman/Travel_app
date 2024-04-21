import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataPage extends StatefulWidget {
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'Country'),
            ),
            TextField(
              controller: _packageController,
              decoration: InputDecoration(labelText: 'Package'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            _selectedImage != null
                ? Container(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          image:  FileImage(_selectedImage!),
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                )
                : Container(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            ),
                        ],
                      ),
                      ),
                    ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  getImageFromGalleryAndUpload();
                },
                child: Text('Add Image'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addPackageData(
                    _cityController.text.trim(),
                    _countryController.text.trim(),
                    _packageController.text.trim(),
                    int.parse(_priceController.text.trim()),
                  );
                },
                child: Text('Add Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getImageFromGalleryAndUpload() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      // Upload the image to Firebase Storage
      final countryName = _countryController.text.trim();
      final imageName = '$countryName.jpg';
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('country_image/$imageName');

      try {
        await firebaseStorageRef.putFile(_selectedImage!);
        print('Image uploaded to Firebase Storage successfully.');

        // Get the image download URL
        final imageUrl = await firebaseStorageRef.getDownloadURL();

        // Add the image URL to Firestore
        await FirebaseFirestore.instance
            .collection('packages')
            .doc(countryName)
            .set({'country_image': imageUrl});

        print('Image URL added to Firestore successfully.');
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> addPackageData(
  String city, String country, String package, int price) async {
  try {
    // Reference to the Firestore collection named "packages"
    final collectionRef = FirebaseFirestore.instance.collection('packages');
    
    // Upload data to Firestore with auto-generated document ID
    await collectionRef.add({
      'city': city,
      'country': country,
      'package': package,
      'price': price,
      'country_image': _selectedImage != null ? await uploadImageAndGetUrl(country) : null,
    });

    print('Package data added successfully!');
    // Clear text fields after adding data
    _cityController.clear();
    _countryController.clear();
    _packageController.clear();
    _priceController.clear();
    setState(() {
      _selectedImage = null;
    });
  } catch (e) {
    print('Error adding package data: $e');
  }
}

Future<String> uploadImageAndGetUrl(String countryName) async {
  try {
    final imageName = '$countryName.jpg';
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('country_image/$imageName');

    // Set cache control to 'no-store' to ensure that the latest image is always fetched
    final metadata = SettableMetadata(
      cacheControl: 'no-store',
    );

    await firebaseStorageRef.putFile(
      _selectedImage!,
      metadata,
    );

    print('Image uploaded to Firebase Storage successfully.');
    return await firebaseStorageRef.getDownloadURL();
  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
    return '';
  }
}
}


