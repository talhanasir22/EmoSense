import 'dart:async';
import 'package:emo_sense/Pages/signin_page.dart';
import 'package:emo_sense/Pages/home_page.dart';
import 'package:flutter/material.dart';
import '../helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnLoginState();
  }

  void _navigateBasedOnLoginState() async {
    // Check login state from SharedPreferences
    bool isLoggedIn = await UserPreferences.isLoggedIn();

    // Navigate to the appropriate page
    Timer(const Duration(milliseconds: 1500), () {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5e17eb),
      child: Image.asset(
        'assets/Images/Logo.png',
      ),
    );
  }
}
