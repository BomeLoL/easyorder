import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/screens/factura/components/dialogsFactura.dart';
import 'package:easyorder/views/screens/factura/components/customButton.dart';
import 'package:easyorder/views/screens/factura/layouts/EmptyState.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/productCard/listorder_card.dart';


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
    UserController userController = Provider.of<UserController>(context, listen: false);
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
              child: EmptyStateLayout(
                size: size,
                onButtonPressed: () {
                  Navigator.of(context).popUntil((route) {
                    return route.settings.name == 'menu';
                  });
                },
              ),
            );
          } else {
            return Background_image(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight + MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      'Mis Pedidos',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 25,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: checkcontroller.pedido.productos.length,
                        itemBuilder: (context, index) {
                          final producto = checkcontroller.pedido.productos[index];        
                          return Column(
                            children: [
                              ListorderCard(
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
                    const Spacer(),
                    Container(
                      height: 150, // Cambiar a 180 con Sub-total y Descuentos
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 95, 4, 1),
                            Colors.red,
                          ],
                        ),
                      ),
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
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              child: CustomButton(
                                text: 'Realizar pago',
                                onPressed: () async {
                                  CartController cartController = Provider.of<CartController>(context, listen: false);
                                  final tester = await MongoDatabase.Test();
                                  if (tester == false) {
                                    dbErrorDialog(context);
                                  } else {
                                    if (userController.usuario != null) {
                                      await DialogsFactura.showOptionDialog(
                                        context,
                                        () {
                                          setState(() {
                                            paypal = false;
                                          });
                                        },
                                        () {
                                          setState(() {
                                            paypal = true;
                                          });
                                        },
                                      );
                                      await DialogsFactura.showConfirmationDialog(
                                        context,
                                        '¿Terminar su estadía?',
                                        'Desea procesar su pago?',
                                        () async {
                                          setState(() {
                                            confirmation = true;
                                          });
                                          if (paypal == true && saldo > checkcontroller.getTotalAmount()) {
                                            saldo -= checkcontroller.getTotalAmount();
                                            userController.usuario!.saldo = saldo;
                                            await _auth.updateUser(userController.usuario!);
                                            userController.usuario = await _auth.getUserByEmailAndAccount(
                                              userController.usuario!.correo,
                                              userController.usuario!.cuenta,
                                            );
                                            await MongoDatabase.vaciarPedidosDeMesa(widget.restaurante.id, widget.idMesa);
                                            cartController.haPedido = false;
                                            await DialogsFactura.showPayDialog(context, "Confirmación de pago", "Tu pago ha sido procesado de manera exitosa.", 'images/check_icon.png', 
                                            () async {
                                            Navigator.of(context).popUntil((route) {
                                              return route.settings.name == 'menu';
                                            });
                                            Navigator.pop(context);
                                            });
                                          } else if (paypal == true && saldo < checkcontroller.getTotalAmount()) {
                                            DialogsFactura.showAlertDialog(context, 'Fondos Insuficientes', 'No hay fondos en su cuenta para realizar este pago');
                                          } else {
                                            await MongoDatabase.vaciarPedidosDeMesa(widget.restaurante.id, widget.idMesa);
                                            cartController.haPedido = false;
                                            Navigator.of(context).popUntil((route) {
                                              return route.settings.name == 'menu';
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                      );
                                    } else {
                                      await DialogsFactura.showConfirmationDialog(
                                        context,
                                        '¿Terminar su estadía?',
                                        'Al confirmar, un mesero vendrá a atenderle para procesar el pago. ¿Desea continuar?',
                                        () async {
                                          setState(() {
                                            confirmation = true;
                                          });
                                          await MongoDatabase.vaciarPedidosDeMesa(widget.restaurante.id, widget.idMesa);
                                          cartController.haPedido = false;
                                          Navigator.of(context).popUntil((route) {
                                            return route.settings.name == 'menu';
                                          });
                                            Navigator.pop(context);
                                        },
                                      );
                                    }
                                  }
                                },
                                backgroundColor: Colors.white,
                                textColor: const Color.fromRGBO(255, 95, 4, 1),
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
          }
        },
      ),
    );
  }
}
