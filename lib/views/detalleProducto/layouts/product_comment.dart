import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductComment extends StatelessWidget {
  final TextController controller;
  const ProductComment({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Comentarios adicionales',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Hazle saber al restaurante los detalles a tener en cuenta al preparar tu pedido.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: 25),
        TextField(
          controller: controller.getController('field1'),
          style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black),
          cursorColor: primaryColor,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: primaryColor, width: 2), // Border color when focused
              ),
              hintText: '(Opcional)',
              hintStyle:
                  GoogleFonts.poppins(fontSize: 14.0, color: Colors.black38)),
        ),
      ],
    );
  }
}
