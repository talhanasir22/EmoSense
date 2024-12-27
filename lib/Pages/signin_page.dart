import 'package:emo_sense/Pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Custom Widgets/primary_btn.dart';
import '../Firebase/auth.dart';
import 'forgotpassword_page.dart';
import 'home_page.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}
class _SignInPageState extends State<SignInPage> {
  final _auth = Auth();
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
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            Opacity(
              opacity: _isLoading ? 0.5 : 1,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 30,
                    right: 0,

                    child: SizedBox(
                      height: 300,
                      child: Image.asset('assets/Images/signinImg.png'),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 260,),
                        Container(
                          height: 440,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade300, // Purple color
                                Colors.black12,    // Dark grey color
                              ],
                              begin: Alignment.topCenter,  // Start of the gradient
                              end: Alignment.center, // End of the gradient
                            ),
                          ),

                          child: Center(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Welcome Back!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 55,
                                  width: 314,
                                  child: TextField(
                                    onTap: () {
                                      if (_isLoading) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
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
                                  height: 55,
                                  width: 314,
                                  child: TextField(
                                    onTap: () {
                                      if (_isLoading) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
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
                                          if (_isLoading) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          } else {
                                            setState(() {
                                              _isObscured = !_isObscured;
                                            });
                                          }
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
                                          if (_isLoading) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              const ForgotPasswordPage(),
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
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: PrimaryButton(
                                    text: 'Login',
                                    colors: Colors.purple.shade300,
                                    textColor: Colors.white,
                                    onPress: () {
                                      FocusScope.of(context).unfocus();
                                      if (emailController.text.isEmpty ||
                                          passwordController.text.isEmpty) {
                                        showErrortoast("Please fill all the fields");
                                      } else {
                                        if (_isLoading) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        } else {
                                          _signin();
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    emailController.clear();
                                    passwordController.clear();
                                    if (_isLoading) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
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
                ],
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
