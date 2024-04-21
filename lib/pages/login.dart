import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency/data/constants.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:travel_agency/admin/admin_home.dart';
import 'package:travel_agency/admin/admin_login.dart';
import 'package:travel_agency/pages/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Get the user's email
    final String userEmail = userCredential.user!.email!;
    
    // Check if the user is an admin
    if (userEmail == 'owner@gmail.com') {
      // Navigate to the AddDataPage for admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddDataPage()),
      );
    } 
  } catch (error) {
    print("Error signing in: $error");
    // Handle error (e.g., show error message)
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: 350,
                height: 250,
              ),
              SizedBox(height: 10),

              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 230, 113, 4),
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

              // forgot password

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // sign in button

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 113, 4),
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
              SizedBox(height: 25),

              // register button

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member?"),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: Text(
                      " Register now",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),

              // admin button

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AdminLoginPage();
                          },
                        ),
                      );
                    },
                    child: Text(
                      " Admin?",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
