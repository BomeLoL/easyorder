import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/pantallaCarga.dart';


Future<void> _showConfirmationDialog(BuildContext context, bool confirmation, widget, bool shouldPop, bool funciona, Future<void> showAlertDialog) {
  bool isButtonPressed = false;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title:  Text(
              '¿Desea enviar su orden?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            content: const Text(
              'Si selecciona confirmar, su pedido se enviará a la cocina.',
              textAlign: TextAlign.justify,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                      confirmation = false;
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                      )
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isButtonPressed
                        ? null
                        : () async {
                            setState(() {
                              isButtonPressed = true;
                            });

                            var verificador = true;
                            try {
                              CartController cartController = Provider.of<CartController>(context, listen: false);
                              var r = await MongoDatabase.getRestaurante(widget.restaurante.id);
                              if (r != null) {
                                MongoDatabase.agregarPedidoARestaurante(r, widget.idMesa, cartController.pedido);
                                await MongoDatabase.actualizarRestaurante(r);
                              } else {
                                verificador = false;
                              }
                            } catch (e) {
                              verificador = false;
                            }
                            if (verificador == true) {
                              shouldPop = false;
                              CartController cartController = Provider.of<CartController>(context, listen: false);
                              CheckController checkController = Provider.of<CheckController>(context, listen: false);
                              Pedido pedidoVacio = Pedido(productos: []);
                              checkController.pedido = cartController.pedido;
                              cartController.pedido = pedidoVacio;
                              Navigator.pop(context, true);
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return const pantallaCarga();
                                }),
                              );
                              funciona = true;
                              confirmation = true;
                            } else {
                              Navigator.pop(context);
                              showAlertDialog;
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                      )
                    ),
                    child: Text(
                      'Confirmar',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}