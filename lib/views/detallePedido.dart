import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/pantallaCarga.dart';

class detallePedido extends StatefulWidget {
  const detallePedido(
      {super.key,
      required this.info,
      required this.menu,
      required this.restaurante, required this.idMesa});
      
  final String info;
  final Restaurante restaurante;
  final Menu menu;
  final int idMesa;

  @override
  State<detallePedido> createState() => _detallePedidoState();
}

class _detallePedidoState extends State<detallePedido> {
  
  bool funciona = false;
  bool confirmation = false;
  bool shouldPop = true;
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
          if (cartController.totalCantidad() == 0 && shouldPop == true){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) {
                return route.settings.name == 'menu';
              });
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
                              onPressed: () async {
                              final tester = await MongoDatabase.Test();
                              if (tester == false){
                              // ignore: use_build_context_synchronously
                              dbErrorDialog(context);
                              }
                              else{
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
          backgroundColor: Colors.white,
          title: Text(
            'Error',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            'Hubo un error inesperado procesando tu orden, por favor, inténtelo de nuevo',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  'Ok',
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(255, 96, 4, 1),
                    fontWeight: FontWeight.bold,
                  ),
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
        
        showCustomPopup(
          pop: false,
          context: context,
          title: 
            '¡Pedido completado!',
          content: const Text(
            'Ya tu pedido está en la cocina y estará listo dentro de poco.',
            textAlign: TextAlign.justify,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) {
                     return route.settings.name == 'menu';
                   });
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    color: const Color.fromRGBO(255, 96, 4, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
}


Future<void> _showConfirmationDialog(BuildContext context) {
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
                          color: Color.fromRGBO(255, 96, 4, 1),
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
                              Pedido pedidoVacio = Pedido(productos: {});
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
                              _showAlertDialog(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 96, 4, 1),
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

}