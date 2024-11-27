import 'package:emo_sense/auth_page.dart';
import 'package:emo_sense/primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _auth = AuthPage();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(_isLoading) {
          setState(() {
            _isLoading = false;
          });
        }
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Recover Password',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ),
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: _isLoading ? 0.5 : 1,
              child: Padding(
              padding: const EdgeInsets.all(20.0), // Add padding for a better layout
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures it fits the screen without overflow
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email here',
                          hintStyle: const TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Get link',
                    colors: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    onPress: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please enter your email',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true; // Trigger loading state
                      });

                      try {
                        // Attempt to recover the password
                        await _auth.recoverPassword(email);
                      } finally {
                        setState(() {
                          _isLoading = false; // Ensure loading state is stopped
                        });
                      }
                    },
                  ),


                ],
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
}
