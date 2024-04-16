import 'package:flutter/material.dart';
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
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }

  Future<void> addPackageData(
      String city, String country, String package, int price) async {
    try {
      // Reference to the Firestore collection named "packages"
      await FirebaseFirestore.instance.collection('packages').add({
        'city': city,
        'country': country,
        'package': package,
        'price': price,
      });

      print('Package data added successfully!');
      // Clear text fields after adding data
      _cityController.clear();
      _countryController.clear();
      _packageController.clear();
      _priceController.clear();
    } catch (e) {
      print('Error adding package data: $e');
    }
  }
}
