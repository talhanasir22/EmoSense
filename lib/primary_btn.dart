import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.colors,
    this.textColor,
    required this.onPress, // This is correctly declared
  });

  final String text;
  final Color colors;
  final Color? textColor;
  final VoidCallback onPress; // Correct declaration

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPress, // Use the onPress parameter here
        style: ElevatedButton.styleFrom(
          backgroundColor: colors,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
