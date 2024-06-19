import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/restaurante_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/factura.dart';
import 'package:easyorder/views/profile_view.dart';
import 'package:easyorder/views/vistaMesas.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:easyorder/views/walletView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BarNavigationRestaurant extends StatefulWidget {
  const BarNavigationRestaurant({
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
  State<BarNavigationRestaurant> createState() => _NavigationbarClientState();
}

class _NavigationbarClientState extends State<BarNavigationRestaurant> {
  bool confirmation = false;
  int selectedIndex = 0;
  bool isWalletSelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer5<CartController, NavController, CheckController,
        UserController, RestauranteController>(
      builder: (context, cartController, navController, checkController,
          userController, restauranteController, child) {
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
                Icons.menu_book_rounded,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Gestión de Menu",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.table_restaurant,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Gestión de Mesas",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Perfil",
            ),
          ],
          currentIndex: navController.selectedIndex,
          onTap: (int clickedIndex) async {
            print("AAAAAAAAAAAAAAAAAAAAAAAA ${clickedIndex}");
            if (clickedIndex == 0) {
              setState(() {
                navController.selectedIndex = clickedIndex;
              });
              Navigator.of(context).popUntil((route) {
                return route.settings.name == 'menu';
              });
            } else if (clickedIndex == 1) {
              print("AAAAAAAAAAAAAAAAA");
              setState(() {
                navController.selectedIndex = clickedIndex;
              });

              restauranteController.getMesas(context);
              // aqui va lo de gestionar mesas
            } else if (clickedIndex == 2) {
              setState(() {
                navController.selectedIndex = clickedIndex;
                Navigator.of(context).popUntil((route) {
                  return route.settings.name == 'menu';
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileView(
                    idMesa: widget.idMesa,
                    info: widget.info,
                    restaurante: widget.restaurante,
                  );
                }));
              });
            }
          },
        );
      },
    );
  }
}
