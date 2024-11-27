import 'package:emo_sense/forgotpassword_page.dart';
import 'package:emo_sense/home_page.dart';
import 'package:emo_sense/primary_btn.dart';
import 'package:emo_sense/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}
class _SignInPageState extends State<SignInPage> {
  final AuthPage _auth = AuthPage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;

  void showErrortoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide loading indicator on tap anywhere
        if (_isLoading) {
          setState(() {
            _isLoading = false;
          });
        }
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: _isLoading ? 0.5 : 1,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/Images/Logo.png'),
                        radius: 100,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome to EmoSense',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 440,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.deepPurpleAccent,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 50,
                                width: 320,
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: 'Email Address',
                                    hintStyle: const TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 50,
                                width: 320,
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: _isObscured,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                      icon: _isObscured
                                          ? const Icon(Icons.visibility, size: 20)
                                          : const Icon(Icons.visibility_off, size: 20),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const ForgotPasswordPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              PrimaryButton(
                                text: 'Login',
                                colors: Colors.white,
                                textColor: Colors.black,
                                onPress: () {
                                  if(emailController.text.isEmpty || passwordController.text.isEmpty){
                                    showErrortoast("Please fill all the fields");
                                  }
                                  else{
                                    _signin();
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  emailController.clear();
                                  passwordController.clear();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Don\'t have an account? Create new',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.7,  // Adjust the opacity as needed
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                    ),
                  ),
                ),
              ),
          ],
        ),

      ),
    );
  }

  void _signin() async {
    setState(() {
      _isLoading = true; // Show the loading spinner when login is in progress
    });

    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await _auth.signinwithemail(email, password);
      setState(() {
        _isLoading = false; // Hide the loading spinner after the operation is complete
      });

      if (user != null) {
        emailController.clear();
        passwordController.clear();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide the progress indicator
      });
    }
    }

}
