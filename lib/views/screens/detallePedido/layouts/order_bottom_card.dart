import 'package:flutter/material.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/productCard/order_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/screens/pantallaCarga/pantallaCarga.dart';

class OrderBottomCard extends StatefulWidget {
  final CartController controller;
  final Future<void> showConfirmationDialog;
  final Future<void> showAlertDialog;
  final bool confirmation;
  final bool funciona;
  const OrderBottomCard({super.key, required this.controller, required this.showConfirmationDialog, required this.showAlertDialog, required this.confirmation, required this.funciona});

  @override
  State<OrderBottomCard> createState() => _OrderBottomCardState();
}

class _OrderBottomCardState extends State<OrderBottomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
                    height: 150, // Cambiar a 180 con Sub-total y Descuentos
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: const LinearGradient(
                          colors: [
                            primaryColor,
                            Colors.red,
                          ],
                        )),
                    child: Column(
                      children: [  
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${widget.controller.getTotalAmount()}',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                       
                        Expanded(
                          flex: 1, //Cambiar a 3 cuando se agrege nuevamente el Sub-total y Descuento
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                              final tester = await MongoDatabase.Test();
                              if (tester == false){
                              // ignore: use_build_context_synchronously
                              dbErrorDialog(context);
                              }
                              else{
                                await widget.showConfirmationDialog;
                                if (widget.confirmation) {
                                  if (widget.funciona) {
                                    //Se hace una pequeña espera a la base de datos y después se continúa
                                    await Future.delayed(
                                        const Duration(seconds: 5));
                                    widget.controller.haPedido = true;
                                    Navigator.of(context).popUntil((route) {
                                      return route.settings.name == 'menu';
                                    });
                                  } else {
                                    Navigator.pop(context);
                                    widget.showAlertDialog;
                                  }
                                }
                              }},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: Text(
                                'Ordenar',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
  }
}