import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:travel_agency/admin/admin_home.dart';
import 'package:travel_agency/data/constants.dart';


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
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Image.asset(
              'assets/images/admin.jpg',
              width: 350,
              height: 250,
            ),
            SizedBox(height: 10),
      
            Text(
              "Welcome Admin!",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 61, 133, 221),
              ),
            ),
      
            Text(
              'LogIn below with your details.',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
      
            SizedBox(
              height: 50,
            ),
      
            // email box
      
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: MaterialTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hint: 'Email',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.email_outlined),
                suffixIcon: const Icon(Icons.check),
              ),
            ),
            SizedBox(height: 10),
      
            // password box
      
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: MaterialTextField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                hint: 'Password',
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: const Icon(Icons.visibility_off),
                obscureText: true,
              ),
            ),
            SizedBox(height: 30),
      
            // sign in button
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: signIn,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 61, 133, 221),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
}
