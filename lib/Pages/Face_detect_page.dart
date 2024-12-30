import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

class FaceDetectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple.shade400,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Spacing for animated text
            SizedBox(height: 20),
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Welcome to EmoSense',
                    textStyle: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                repeatForever: false,
                totalRepeatCount: 1,
              ),
            ),

            const SizedBox(height: 100,),
            SizedBox(
              height: 200,
              width: 180,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraPage()));
                },
                child: Card(
                  elevation: 20,
                  color: Colors.purple.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.purple.shade400,
                        backgroundImage: AssetImage('assets/Images/emoji.png'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tap me to detect',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10), // Small spacing at the bottom
          ],
        ),
      ),
    );
  }
}



