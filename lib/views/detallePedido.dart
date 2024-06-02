import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
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
                              menu: widget.menu,
                              restaurante: widget.restaurante,
                              idMesa: widget.idMesa,
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
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
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
                        ),
                        Spacer(),
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
                              final tester = await MongoDatabase.Test();
                              if (tester == false){
                              // ignore: use_build_context_synchronously
                              dbErrorDialog(context);}
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
          title: Text(
            'ERROR!!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Hubo un error inesperado procesando tu orden, por favor, inténtelo de nuevo',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  'OK',
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
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(
            'Pedido completado!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Ya tu pedido está en la cocina y estará listo dentro de poco',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return MenuView(info: widget.restaurante.id, restaurante: widget.restaurante, menu: widget.menu, idMesa: widget.idMesa);
                  }));
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(255, 96, 4, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
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
                  TextButton(
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
                              }
                            } catch (e) {
                              verificador = false;
                            }
                            if (verificador == true) {
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
    },
  );
}

}