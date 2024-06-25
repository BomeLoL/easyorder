import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrangeTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OrangeTextButton({
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
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFFFF5F04),
            side: BorderSide(width: 2, color: Color(0xFFFF5F04)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.height * 0.018,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
