import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/screens/Questions/questions_screen.dart';
import 'package:easyorder/views/screens/factura/facturaView.dart';
import 'package:easyorder/views/screens/profile/profile_view.dart';
import 'package:easyorder/views/screens/QR/vistaQr.dart';
import 'package:easyorder/views/screens/Wallet/walletView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BarNavigationClientLogged extends StatefulWidget {
  const BarNavigationClientLogged({
    super.key,
    this.index,
    required this.info,
    required this.restaurante,
    required this.idMesa,
  });

  final index;
  final String info;
  final Restaurante restaurante;
  final int idMesa;

  @override
  State<BarNavigationClientLogged> createState() => _NavigationbarClientState();
}

class _NavigationbarClientState extends State<BarNavigationClientLogged> {
  bool confirmation = false;
  int selectedIndex = 0;
  bool isWalletSelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer4<CartController, NavController, CheckController,
        UserController>(
      builder: (context, cartController, navController, checkController,
          userController, child) {
        return BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          fixedColor: Color.fromRGBO(142, 142, 142, 1),
          unselectedItemColor: Color.fromRGBO(142, 142, 142, 1),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code,
                size: 45.0,
                color: checkController.pedido.productos.length >0 ? Colors.grey :primaryColor,
              ),
              label: "Escanear",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.wallet,
                size: 35,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Billetera",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment_outlined,
                size: 35,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Pedidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                size: 35,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Perfil",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer_outlined,
                  size: 35,
                  color: primaryColor,
                ),
                label: 'Preguntas')
          ],
          currentIndex: navController.selectedIndex,
          onTap: (int clickedIndex) async {
            Provider.of<SpinnerController>(context, listen: false)
                .setLoading(false);
            if (clickedIndex == 3) {
              setState(() {
                navController.selectedIndex = clickedIndex;
                Navigator.of(context).popUntil((route) {
                  return route.settings.name == 'menu';
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileView(
                    info: widget.info,
                    idMesa: widget.idMesa,
                    restaurante: widget.restaurante,
                  );
                }));
              });
            } else if (clickedIndex == 2) {
              setState(() {
                navController.selectedIndex = clickedIndex;
              });

              Pedido? pedido = await MongoDatabase.consolidarPedidos(
                  widget.restaurante.id, widget.idMesa);

              if (pedido != null) {
                if (pedido.productos.isEmpty) {
                  cartController.haPedido = false;
                } else {
                  cartController.haPedido = true;
                }
                checkController.pedido = pedido;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Factura(
                    info: widget.info,
                    idMesa: widget.idMesa,
                    restaurante: widget.restaurante,
                  );
                }),
              );
            } else if (clickedIndex == 0 && cartController.haPedido == false) {
              setState(() {
                navController.selectedIndex = clickedIndex;
              });

              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BarcodeScannerWithOverlay();
              }));
            } else if (clickedIndex == 0 && cartController.haPedido == true) {
            } else if (clickedIndex == 1 ) {
              setState(() {
                navController.selectedIndex = clickedIndex;
              });
              Navigator.of(context).popUntil((route) {
                return route.settings.name == 'menu';
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return walletView(
                      idMesa: widget.idMesa,
                      info: widget.info,
                      restaurante: widget.restaurante,
                    );
                  },
                ),
              );
            } else if (clickedIndex == 4) {
              setState(() {
                navController.selectedIndex = clickedIndex;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionsScreen(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
