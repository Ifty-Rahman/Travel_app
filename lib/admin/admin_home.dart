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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _daysController,
                decoration: InputDecoration(labelText: 'Days'),
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
                              image: FileImage(_selectedImage!),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final ImagePicker _picker = ImagePicker();
                        _picker
                            .pickImage(source: ImageSource.gallery)
                            .then((image) {
                          if (image != null) {
                            setState(() {
                              _selectedImage = File(image.path);
                            });
                          }
                        });
                      },
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: Text(
                        'Clear Image',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    addPackageData(
                      _cityController.text.trim(),
                      _countryController.text.trim(),
                      _packageController.text.trim(),
                      _descriptionController.text.trim(),
                      int.parse(_priceController.text.trim()),
                      int.parse(_daysController.text.trim()),
                    );
                  },
                  child: Text(
                    'Add Data',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addPackageData(String city, String country, String package,
      String description, int price, int days) async {
    try {
      // Reference to the Firestore collection named "packages"
      final collectionRef = FirebaseFirestore.instance.collection('packages');

      // Check if an image is selected
      if (_selectedImage != null) {
        // Upload image to Firebase Storage
        String imageName = '${country.toLowerCase()}.jpg'; // Set image name
        Reference storageRef =
            FirebaseStorage.instance.ref().child('country_images/$imageName');
        await storageRef.putFile(_selectedImage!);
        String imageUrl = await storageRef.getDownloadURL();

        // Add package data to Firestore with image URL
        await collectionRef.add({
          'city': city,
          'country': country,
          'package': package,
          'description': description,
          'price': price,
          'days': days,
          'country_image': imageUrl, // Store image URL in Firestore
        });
      } else {
        // Add package data to Firestore without image URL
        await collectionRef.add({
          'city': city,
          'country': country,
          'package': package,
          'description': description,
          'price': price,
          'days': days,
        });
      }

      print('Package data added successfully!');
      // Clear text fields after adding data
      _cityController.clear();
      _countryController.clear();
      _packageController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _daysController.clear();
      setState(() {
        _selectedImage = null;
      });
    } catch (e) {
      print('Error adding package data: $e');
    }
  }
}
