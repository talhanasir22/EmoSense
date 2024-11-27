import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryContainer extends StatelessWidget {
  const PrimaryContainer({
    super.key,
    required this.image,
    required this.text,
    required this.Pagetitle,
  });

  final Image image;
  final String text;
  final String Pagetitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add navigation or action logic here if needed
      },
      child: Container(
        height: 150,
        width: 170,
        decoration: BoxDecoration(
          color: const Color(0xff8c52ff),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: image,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
