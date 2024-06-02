import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';


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
                color: Color.fromRGBO(255, 95, 4, 1),
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
                    backgroundColor: Color.fromRGBO(255, 95, 4, 1),
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



