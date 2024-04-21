import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_agency/pages/admin_home.dart';


class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final DocumentSnapshot<Map<String, dynamic>> adminSnapshot = await FirebaseFirestore.instance.collection('Admin').doc(email).get();

      if (adminSnapshot.exists) {
        final String storedPassword = adminSnapshot.data()!['password'];

        // Check if the entered password matches the stored password
        if (password == storedPassword) {
          // Navigate to the AddDataPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddDataPage()),
          );
        } else {
          // Show password incorrect error
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Incorrect Password'),
                content: Text('Please enter the correct password.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Show user not found error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('User Not Found'),
              content: Text('Please enter a valid email.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print("Error signing in: $error");
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
