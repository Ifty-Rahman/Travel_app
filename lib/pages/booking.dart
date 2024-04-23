import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:travel_agency/widgets/confirmed.dart';

class BookingPage extends StatefulWidget {
  final String country;
  final String package;
  final String price;
  final String city;
  final String days;

  const BookingPage({
    Key? key,
    required this.country,
    required this.package,
    required this.price,
    required this.city,
    required this.days,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedDate;
  int _numberOfPersons = 1;

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void navigateToConfirmScreen() {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => ConfirmScreen(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    int totalPrice = int.parse(widget.price) * _numberOfPersons;
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country: ${widget.country}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'City: ${widget.city}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Package: ${widget.package}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Duration: ${widget.days} days',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Price: $totalPrice', // Show total price
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Select Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Number of Persons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (_numberOfPersons > 1) {
                      setState(() {
                        _numberOfPersons--;
                      });
                    }
                  },
                ),
                Text(
                  '$_numberOfPersons',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _numberOfPersons++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Check if date is selected
                  if (_selectedDate == null) {
                    // Show snackbar if date is not selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a date!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Initiate PayPal checkout
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaypalCheckout(
                          sandboxMode: true,
                          clientId:
                              "AWavo88toW40JBjA8PPyqr97jwMdZ8VqByQhOXvl4QMi5pxz1EKKNUDSvcNTpId5O9JqKqEglsskms6p",
                          secretKey:
                              "ECSQAp-U3TB7-rjyuSZn_0Q7xMqeXZaN2LNBMWwMng1rrmHy9uVpfHhocIlXXgPxZFH2FEHAJjwN-byr",
                          returnURL: "success.snippetcoder.com",
                          cancelURL: "cancel.snippetcoder.com",
                          transactions: [
                            {
                              "amount": {
                                "total": totalPrice.toString(),
                                "currency": "USD",
                              },
                              "description":
                                  "Booking payment for ${widget.package}",
                            }
                          ],
                          note:
                              "Booking payment for ${widget.package} (${widget.days} days)",
                          onSuccess: (params) async {
                            // Payment success, push booking information to Firebase
                            String? userEmail =
                                FirebaseAuth.instance.currentUser?.email;
                            if (userEmail != null) {
                              await FirebaseFirestore.instance
                                  .collection('bookings')
                                  .add({
                                'country': widget.country,
                                'city': widget.city,
                                'package': widget.package,
                                'days': widget.days,
                                'price': totalPrice,
                                'date': _selectedDate,
                                'numberOfPersons': _numberOfPersons,
                                'email': userEmail,
                              });
                            }
                            navigateToConfirmScreen(); // Navigate to ConfirmScreen
                          },
                          onError: (error) {
                            print("onError: $error");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to process payment!'),
                              ),
                            );
                          },
                          onCancel: () {
                            print('Payment cancelled');
                          },
                        ),
                      ),
                    );
                  }
                },
                child: Text('Book Now with PayPal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
