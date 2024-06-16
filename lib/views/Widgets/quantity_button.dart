import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class QuantityButton extends StatelessWidget {
  final VoidCallback agregar;
  final VoidCallback eliminar;
  final int cantidad;

  QuantityButton({
    required this.agregar,
    required this.eliminar,
    required this.cantidad,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: IconButton(
                onPressed: () {
                  eliminar();
                },
                icon: Icon(Icons.remove),
                style: IconButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 95, 4, 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    )),
                color: primaryColor,
                iconSize: 20,
              ),
            ),
          ),
          const Spacer(flex: 1,),
          Expanded(
            flex: 2,
            child: Text(
              cantidad.toString(),
              style: GoogleFonts.poppins(),
              textAlign: TextAlign.center,
            ),
          ), //implementar funcionalidad
          const Spacer(flex: 1,),
          Expanded(
            flex: 3,
            child: Container(
              
              child: IconButton(
                onPressed: () {
                  agregar();
                },
                icon: Icon(Icons.add),
                style: IconButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    )),
                color: Colors.white,
                iconSize: 20,
              ),
            ),
          ),
        ],
      );
  }
}



