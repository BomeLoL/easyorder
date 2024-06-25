import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrangeBackgroundButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OrangeBackgroundButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 55,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5F04),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.height * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
