import 'package:emo_sense/auth_page.dart';
import 'package:emo_sense/primary_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthPage _auth = AuthPage();
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
        body: Stack(
          children: [
            Opacity(
              opacity: _isLoading ? 0.5 : 1.0,
              child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/Images/Logo.png'),
                      radius: 100,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 500,
                      child: Container(
                        height: double.infinity, // Fixed height
                        width: double.infinity, // Full width of the screen
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
                                  'Create New \n   Account',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32),
                                ),
                              ),
                              const SizedBox(height:20 ,),
                              SizedBox(
                                height: 50,
                                width: 320, // Set a fixed width for the text field
                                child: TextField(
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
                                height: 50,
                                width: 320, // Set a fixed width for the text field
                                child: TextFormField(
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
                                height: 50,
                                width: 320, // Set a fixed width for the text field
                                child: TextField(
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
                                height: 50,
                                width: 320, // Set a fixed width for the text field
                                child: TextFormField(
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
                                colors: Colors.white,
                                textColor: Colors.black,
                                onPress: () {
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
                                    _signUp();
                                  }
                                },
                              ),
                              const SizedBox(height: 1),
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Already Registered? SignIn',
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
                    ),
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
      ]
        ),
      ),
    );
  }
  void _signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

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