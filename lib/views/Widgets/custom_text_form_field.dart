import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({required this.controller, required this.hintText, this.keyboardType = TextInputType.text, this.validator = null});
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? validator;
 

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: Colors.black),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        errorStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
        ),
        focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:primaryColor,
          width: 2
          ),
      ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.black38)),
        validator: (value) {
          if (validator != null && (value == null || value.trim().isEmpty)) {
            return validator;
          }
          return null;
        }, 
    );
  }

}