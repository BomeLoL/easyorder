import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductInfo extends StatelessWidget {
  final ItemMenu producto;
  const ProductInfo({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(producto.nombreProducto, style: biggerTitle),
        SizedBox(height: 25),
        Text(
          '\$${producto.precio}',
          textAlign: TextAlign.justify,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 25),
        Text(producto.descripcion,
            textAlign: TextAlign.justify, style: normalTextStyle),
        SizedBox(height: 25),
      ],
    );
  }
}
