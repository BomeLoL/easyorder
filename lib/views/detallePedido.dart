import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/pantallaCarga.dart';

class detallePedido extends StatefulWidget {
  const detallePedido({super.key});

  @override
  State<detallePedido> createState() => _detallePedidoState();
}

class _detallePedidoState extends State<detallePedido> {
  bool funciona = false;
  bool confirmation = false;
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
                  SizedBox(height: kToolbarHeight + 40),
                  Text(
                    'Detalles del pedido',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(20),
                  Expanded(
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
                              isPedido: 0,
                            ),
                            const Gap(20),
                          ],
                        );
                      },
                    ),
                  ),
                  Gap(40),
                  Container(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sub-Total:',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '1111',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Descuento:',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '0',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Gap(10),
                        Row(
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
                        Gap(10),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _showConfirmationDialog(context);
                              if (confirmation) {
                                if (funciona) {
                                  //Se hace una pequeña espera a la base de datos y después se continúa
                                  await Future.delayed(
                                      const Duration(seconds: 5));
                                  Navigator.pop(context);
                                  _showSuccessDialog(context);
                                } else {
                                  Navigator.pop(context);
                                  _showAlertDialog(context);
                                }
                              }
                            },
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
                                color: Color.fromRGBO(255, 95, 4, 1),
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

  //Esta función muestra el mensaje de error de cuando la orden falla
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ERROR!!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Hubo un error procesando tu orden, por favor, inténtelo de nuevo',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 96, 4, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //Esta función muestra la ventanilla que indica que la orden fue completada exitosamente
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pedido completado!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Ya tu pedido está en la cocina y estará listo dentro de poco',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 96, 4, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
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
            'Está seguro de enviar su orden?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const pantallaCarga();
                      }),
                    );
                    funciona = true;
                    confirmation = true;
                  },
                  child: const Text(
                    'Si',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 96, 4, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    confirmation = false;
                  },
                  child: const Text(
                    'No',
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
