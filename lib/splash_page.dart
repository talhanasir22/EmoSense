import 'dart:async';
import 'package:emo_sense/signin_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignInPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: const Color(0xFF5e17eb),
      child: Image.asset('assets/Images/Logo.png',
      ),
    );
  }
}