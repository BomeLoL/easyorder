import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class finalizarPedido extends StatefulWidget {
  const finalizarPedido(
      {super.key,
      required this.info,
      required this.menu,
      required this.restaurante,
      required this.idMesa});
  final String info;
  final Restaurante restaurante;
  final Menu menu;
  final int idMesa;

  @override
  State<finalizarPedido> createState() => _finalizarPedidoState();
}

class _finalizarPedidoState extends State<finalizarPedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
      ),
      body: Consumer<CartController>(
        builder: (context, cartController, child) {
          return Background_image(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight +
                        MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    'Factura',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 25,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: cartController.pedido.productos.length,
                      itemBuilder: (context, index) {
                        final producto = cartController.pedido.productos.keys
                            .elementAt(index);
                        return Column(
                          children: [
                            ProductCard(
                              producto: producto,
                              isPedido: 2,
                              info: widget.info,
                            ),
                            const Gap(20),
                          ],
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 180,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 95, 4, 1),
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
                                '1111',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _showConfirmationDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: Text(
                                'Finalizar',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 95, 4, 1),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Acción',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Está seguro de finalizar su estadía?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 96, 4, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'Si',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 96, 4, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
