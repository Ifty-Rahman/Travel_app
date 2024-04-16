import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency/data/constants.dart';
import 'package:material_text_fields/material_text_fields.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RegisterPage> {
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp(BuildContext context) async {
    if (passwordConfirmed()) {
      if (_passwordController.text.trim().length >= 6) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          // User successfully created
        } catch (error) {
          // Handle any errors
          print("Error creating user: $error");
          // Show error message in a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${error.toString()}"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Show password length error message in a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password should be 6 or more characters!"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Handle password confirmation error
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
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
                'assets/images/logo.png', // Replace 'assets/logo.png' with your logo image path
                width: 350,
                height: 250,
              ),

              SizedBox(
                height: 15,
              ),

              //Hello

              Text(
                "Ready to travel?",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 230, 113, 4),
                ),
              ),

              Text(
                'Register below with your details.',
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

              SizedBox(
                height: 10,
              ),

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

              SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: MaterialTextField(
                  controller: _confirmpasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  hint: 'Confirm Password',
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
                child: InkWell(
                  onTap: () => signUp(context),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 113, 4),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              // register button

              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?"),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        " Login now",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
