import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/pantallaCarga.dart';

class detallePedido extends StatefulWidget {
  const detallePedido({super.key, required this.info});
  final String info;

  @override
  State<detallePedido> createState() => _detallePedidoState();
}

class _detallePedidoState extends State<detallePedido> {
  bool funciona = false;
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
          if (cartController.totalCantidad() == 0){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
            return SizedBox();
          } else {
            return Background_image(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: kToolbarHeight +
                          MediaQuery.of(context).size.height * 0.03),
                  Text(
                    'Detalles del pedido',
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
                              isPedido: 0,
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
                    height: 150, // Cambiar a 180 con Sub-total y Descuentos
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
                        // Expanded(
                        //   flex: 2,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       // Text(
                        //       //   'Sub-Total:',
                        //       //   style: GoogleFonts.poppins(
                        //       //     fontSize: 16,
                        //       //     color: Colors.white,
                        //       //     fontWeight: FontWeight.bold,
                        //       //   ),
                        //       // ),
                        //       // Text(
                        //       //   cartController.getTotalAmount().toString(),
                        //       //   style: GoogleFonts.poppins(
                        //       //     fontSize: 16,
                        //       //     color: Colors.white,
                        //       //     fontWeight: FontWeight.bold,
                        //       //   ),
                        //       // )
                        //     ],
                        //   ),
                        // ),
                        // Expanded(
                        //   flex: 2,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       // Text(
                        //       //   'Descuento:',
                        //       //   style: GoogleFonts.poppins(
                        //       //     fontSize: 16,
                        //       //     color: Colors.white,
                        //       //     fontWeight: FontWeight.bold,
                        //       //   ),
                        //       // ),
                        //       // Text(
                        //       //   '0',
                        //       //   style: GoogleFonts.poppins(
                        //       //     fontSize: 16,
                        //       //     color: Colors.white,
                        //       //     fontWeight: FontWeight.bold,
                        //       //   ),
                        //       // )
                        //     ],
                        //   ),
                        // ),
                    
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
                                '\$${cartController.getTotalAmount()}',
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
                              onPressed: 
                                () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const pantallaCarga();
                                }),
                              );
                              //Se hace una pequeña espera a la base de datos y después se continúa
                              await Future.delayed(const Duration(seconds: 5));
                              if (funciona) {
                                Navigator.pop(context);
                                _showSuccessDialog(context);
                              } else {
                                Navigator.pop(context);
                                _showAlertDialog(context);
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
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
          }
          
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
}
