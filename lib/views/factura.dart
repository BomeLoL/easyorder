import 'dart:ui';

import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/listorder_card.dart';
import 'package:easyorder/views/Widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/pantallaCarga.dart';

class Factura extends StatefulWidget {
  const Factura({
    super.key,
    required this.info,
    required this.restaurante,
    required this.idMesa,
  });

  final String info;
  final Restaurante restaurante;
  final int idMesa;

  @override
  State<Factura> createState() => _detalleFacturaState();
}

class _detalleFacturaState extends State<Factura> {
  bool confirmation = false;
  bool paypal = false;
  bool shouldPop = true;
  double saldo = 0; 
  final _auth = Authservice();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserController userController =
        Provider.of<UserController>(context, listen: false);
    if (userController.usuario?.saldo != null) {
      saldo = userController.usuario!.saldo;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
      ),
      body: Consumer<CheckController>(
        builder: (context, checkcontroller, child) {
          if (checkcontroller.totalCantidad() == 0 && shouldPop == true) {
            return Background_image(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight + size.height * 0.03,
                    ),
                    Text(
                      'Mis Pedidos',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.18), // Ajusta este tamaño para controlar la altura
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                            child: Image.asset(
                              'images/flyingHamburger.png', // Reemplaza con la ruta de tu imagen
                              height: size.height * 0.23, // Ajusta el tamaño de la imagen según lo necesites
                            ),
                          ),
                          SizedBox(height: 10), // Espacio entre la imagen y el texto
                          Text(
                            'Aún no has realizado pedidos',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6), // Espacio entre los textos
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                            child: Text(
                              'Busca entre todas nuestras opciones y disfruta de tu primer pedido',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.03),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () async {

                                  // Acción del botón
                                Navigator.of(context).popUntil((route) {
                                  return route.settings.name == 'menu';
                                });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF5F04),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Realizar un Pedido",
                                  style: GoogleFonts.poppins(
                                    fontSize: MediaQuery.of(context).size.height * 0.018,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
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
                    'Mis Pedidos',
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
                      itemCount: checkcontroller.pedido.productos.length,
                      itemBuilder: (context, index) {
                        final producto = checkcontroller.pedido.productos[index];        
                        return Column(
                          children: [
                            ListorderCard (
                              producto: producto.producto,
                              info: widget.info,
                              comment: producto.comentario!,
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
                                '\$${checkcontroller.getTotalAmount()}',
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
                          flex: 1, 
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                  CartController cartController =
                                      Provider.of<CartController>(context,
                                          listen: false);
                                  final tester = await MongoDatabase.Test();
                                  if (tester == false) {
                                    // ignore: use_build_context_synchronously
                                    dbErrorDialog(context);
                                  } else {
                                    if (userController.usuario!=null){
                                    await _showOptionDialog(context);
                                    if (paypal == true) {
                                      await _showConfirmationDialog(context);
                                      //Si quiere pagar por paypal y tiene saldo suficiente
                                      if (confirmation == true &&
                                          saldo >
                                              checkcontroller
                                                  .getTotalAmount()) {
                                        //Modifica la cantidad de saldo
                                        saldo = saldo -
                                            checkcontroller.getTotalAmount();
                                        //Lo cambia en la BD
                                        if (userController.usuario != null) {
                                          userController.usuario!.saldo = saldo;
                                          _auth.updateUser(
                                              userController.usuario!);
                                        }
                                        if (userController.usuario != null) {
                                          var updateChangesUser = await _auth
                                              .getUserByEmailAndAccount(
                                            userController.usuario!.correo,
                                            userController.usuario!.cuenta,
                                          );
                                          userController.usuario =
                                              updateChangesUser;
                                        }
                                        await MongoDatabase.vaciarPedidosDeMesa(
                                            widget.restaurante.id,
                                            widget.idMesa);
                                        cartController.haPedido = false;
                                        Navigator.of(context).popUntil((route) {
                                          return route.settings.name == 'menu';
                                        });
                                        Navigator.pop(context);
                                      } else if (confirmation == true &&
                                          saldo <
                                              checkcontroller
                                                  .getTotalAmount()) {
                                        //Si quiere pagar por paypal y tiene saldo insuficiente
                                        _showAlertDialog(context);
                                      }
                                    } else {
                                      //No quiso pagar por paypal
                                      await _showConfirmationDialog(context);
                                      if (confirmation == true) {
                                        await MongoDatabase.vaciarPedidosDeMesa(
                                            widget.restaurante.id,
                                            widget.idMesa);
                                        cartController.haPedido = false;
                                        Navigator.of(context).popUntil((route) {
                                          return route.settings.name == 'menu';
                                        });
                                        Navigator.pop(context);
                                      }
                                    }
                                  } else{
                                      await _showConfirmationDialogWithoutAccount(context);
                                      if (confirmation == true) {
                                        await MongoDatabase.vaciarPedidosDeMesa(
                                            widget.restaurante.id,
                                            widget.idMesa);
                                        cartController.haPedido = false;
                                        Navigator.of(context).popUntil((route) {
                                          return route.settings.name == 'menu';
                                        });
                                        Navigator.pop(context);
                                      }
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
                                'Realizar pago',
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
            'Fondos Insuficientes',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'No hay fondos en su cuenta para realizar este pago',
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

  Future<void> _showOptionDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            '¿Cómo desea pagar?',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Escoja la forma en la que desea pagar',
            textAlign: TextAlign.justify,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      paypal = false;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Text(
                    'Efectivo',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      paypal = true;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Text(
                    'Billetera virtual',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
          backgroundColor: Colors.white,
          title: Text(
            '¿Terminar su estadía?',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Desea procesar su pago?',
            textAlign: TextAlign.justify,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      confirmation = false;
                    });
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      confirmation = true;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Text(
                    'Confirmar',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

Future<void> _showConfirmationDialogWithoutAccount(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          '¿Terminar su estadía?',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Al confirmar, un mesero vendrá a atenderle para procesar el pago. ¿Desea continuar?',
          textAlign: TextAlign.justify,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    confirmation = false;
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.poppins(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    confirmation = true;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                child: Text(
                  'Confirmar',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.bold),
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