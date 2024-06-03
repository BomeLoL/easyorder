import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  
  const CustomPopup({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
      content: content,
      actions: actions,
    );
  }
}

void showCustomPopup({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget> actions = const [],
  bool pop = true,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: pop,
        child: CustomPopup(
          title: title,
          content: content,
          actions: actions,
        ),
      );
    },
  );
}