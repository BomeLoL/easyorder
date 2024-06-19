import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/factura.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:easyorder/views/walletView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BarNavigationClient extends StatefulWidget {
  const BarNavigationClient({
    super.key,
    this.index,
    required this.info,
    required this.menu,
    required this.restaurante,
    required this.idMesa,
  });

  final index;
  final String info;
  final Restaurante restaurante;
  final Menu menu;
  final int idMesa;

  @override
  State<BarNavigationClient> createState() => _NavigationbarClientState();
}

class _NavigationbarClientState extends State<BarNavigationClient> {
  bool confirmation = false;
  int selectedIndex = 0;
  bool isWalletSelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer3<CartController, NavController, CheckController>(
      builder: (context, cartController, navController, checkController, child) {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(142, 142, 142, 1),
          ),
          fixedColor: Color.fromRGBO(142, 142, 142, 1),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Escanear",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.wallet,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Billetera",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment_outlined,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Mis Pedidos",
            ),
          ],
          currentIndex: navController.selectedIndex,
          onTap: (int clickedIndex) async {
            if (clickedIndex == 2) {
              // Actualizamos el índice de la barra de navegación
              setState(() {
                navController.selectedIndex = clickedIndex;
              });

              // Obtenemos el pedido consolidado
              Pedido? pedido = await MongoDatabase.consolidarPedidos(widget.restaurante.id, widget.idMesa);

              if (pedido != null) {
                if (pedido.productos.isEmpty) {
                  cartController.haPedido = false;
                } else {
                  cartController.haPedido = true;
                }
                checkController.pedido = pedido;
              }
              print("object");
              // Navegamos a la página de Factura
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Factura(
                    info: widget.info,
                    idMesa: widget.idMesa,
                    menu: widget.menu,
                    restaurante: widget.restaurante,
                  );
                }),
              );
              print("uwu");
            } else if (clickedIndex == 0 && cartController.haPedido == false) {
              // Actualizamos el índice de la barra de navegación
              setState(() {
                navController.selectedIndex = clickedIndex;
              });

              // Navegamos al escáner de código de barras
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BarcodeScannerWithOverlay();
              }));
            } else if (clickedIndex == 0 && cartController.haPedido == true) {
              // Mostramos el popup de advertencia
              showCustomPopup(
                context: context,
                title: 'Finalice su estadía para escanear',
                content: Text(
                  'Para escanear otro código, primero debes terminar tu sesión actual. Por favor, finaliza tu estadía para continuar.'
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                      )
                    ),
                    child: Text(
                      'Ok',
                      style: GoogleFonts.poppins(
                        color: const Color.fromRGBO(255, 96, 4, 1),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ]
              );
            } else if (clickedIndex == 1 && !navController.isWalletSelected) {
              // Actualizamos el índice de la barra de navegación y el estado de la billetera
              setState(() {
                navController.isWalletSelected = true;
                navController.selectedIndex = clickedIndex;
              });

              // Navegamos a la vista de la billetera
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return walletView(
                      idMesa: widget.idMesa,
                      info: widget.info,
                      menu: widget.menu,
                      restaurante: widget.restaurante,
                    );
                  },
                ),
              ).then((_) {
                // Actualizamos el estado de la billetera al regresar
                setState(() {
                  navController.isWalletSelected = false;
                });
              });
            } else if (clickedIndex == 1 && navController.isWalletSelected) {
              // Actualizamos el índice de la barra de navegación
              setState(() {
                navController.selectedIndex = clickedIndex;
              });
            }
          },
        );
      },
    );
  }
}
