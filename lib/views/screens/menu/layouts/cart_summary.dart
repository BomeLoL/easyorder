import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/screens/detallePedido/detallePedido.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartSummary extends StatefulWidget {
  final String nombreRes;
  final Restaurante restaurante;
  final int idMesa;
  const CartSummary({
    required this.nombreRes,
    required this.restaurante,
    required this.idMesa,
  });

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        if (cartController.pedido.productos.isNotEmpty) {
          final nroProductos = cartController.totalCantidad();
          return Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        nroProductos.toString() + ' producto(s) en el carrito',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => detallePedido(
                                  info: widget.nombreRes,
                                  restaurante: widget.restaurante,
                                  idMesa: widget.idMesa)),
                        );
                      },
                      child: Text(
                        'Ver mi pedido',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container(
            width: 0,
            height: 0,
          );
        }
      },
    );
  }
}
