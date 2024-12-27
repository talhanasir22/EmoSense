import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Custom Widgets/primary_btn.dart';
import '../Firebase/auth.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = Auth();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the email field';
    }

    // Define a regex for validating an email
    final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$');

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  @override
  void dispose(){
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              opacity: _isLoading ? 0.5 : 1.0,
              child: Stack(
                children: [
                  Positioned(
                    left: 140,
                    right: 0,
                    top: -20,
                    child: SizedBox(
                      height: 300,
                      child: Image.asset('assets/Images/loginImg.png'),
                    ),
                  ),
                  SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 220,),
                      SizedBox(
                        height: 500,
                        child: Container(
                          height: double.infinity, // Fixed height
                          width: double.infinity, // Full width of the screen
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
                                    'Get Started Free',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35),
                                  ),
                                ),
                                const SizedBox(height:20 ,),
                                SizedBox(
                                  height: 55,
                                  width: 314, // Set a fixed width for the text field
                                  child: TextField(
                                    onTap: (){
                                      if(_isLoading){
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Name',
                                      hintStyle: const TextStyle(color: Colors.black45),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 55,
                                  width: 314,  // Set a fixed width for the text field
                                  child: TextFormField(
                                      onTap: (){
                                        if(_isLoading){
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Email Address',
                                      hintStyle: const TextStyle(color: Colors.black45),
                                    ),
                                    validator: validateEmail
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 55,
                                  width: 314,  // Set a fixed width for the text field
                                  child: TextField(
                                    onTap: (){
                                      if(_isLoading){
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Password',
                                      hintStyle: const TextStyle(color: Colors.black45),
                                    ),
                                  ),

                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 55,
                                  width: 314, // Set a fixed width for the text field
                                  child: TextFormField(
                                    onTap: (){
                                      if(_isLoading){
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                    controller: _confirmPasswordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Confirm Password',
                                      hintStyle: const TextStyle(color: Colors.black45),
                                    ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Please fill the confirm password field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                PrimaryButton(
                                  text: 'SignUp',
                                  colors: Colors.purple.shade300,
                                  textColor: Colors.white,
                                  onPress: () {
                                    FocusScope.of(context).unfocus();
                                    if (_nameController.text.isEmpty ||
                                        _emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty ||
                                        _confirmPasswordController.text.isEmpty) {
                                      showErrortoast('Please fill all the fields');
                                    }
                                    else if (validateEmail(_emailController.text) != null) {
                                      showErrortoast(validateEmail(_emailController.text)!);
                                    }
                                    else if (_passwordController.text != _confirmPasswordController.text) {
                                      showErrortoast('Password and confirm password do not match.');
                                    }
                                    else {
                                      if(_isLoading){
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                      else{
                                        _signUp();
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(height: 1),
                                TextButton(
                                  onPressed: (){
                                    FocusScope.of(context).unfocus();
                                    if(_isLoading){
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                    else{
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:15.0),
                                    child: const Text(
                                      'Already Registered? SignIn',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
      ]
        ),
      ),
    );
  }
  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true; // Update the state to show the progress indicator
    });

    try {
      User? user = await _auth.signupwithemail(email, password);

      if (user != null) {
        setState(() {
          _isLoading = false; // Hide the progress indicator
        });
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide the progress indicator
      });
    }
  }

}