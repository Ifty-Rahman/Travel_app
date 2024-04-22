import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_agency/pages/show_bookings.dart';

class ConfirmScreen extends StatefulWidget {
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  void initState() {
    super.initState();
    // After a delay, navigate to the login page
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ShowBookingsPage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/confirmed.gif',
                width: 400,
                height: 400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35,),
              child: Text(
                "Booking Confirmed! Redirecting to Bookings Page...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
