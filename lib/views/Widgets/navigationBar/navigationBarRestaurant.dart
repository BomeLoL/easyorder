import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/restaurante_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/views/screens/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/screens/Questions/questions_screen.dart';

class BarNavigationRestaurant extends StatefulWidget {
  const BarNavigationRestaurant({
    super.key,
    this.index,
  });

  final index;

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
              label: "Menu",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.table_restaurant,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Mesas",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Perfil",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer_outlined,
                  size: 45.0,
                  color: Color.fromRGBO(255, 95, 4, 1),
                ),
                label: 'Preguntas')
          ],
          currentIndex: navController.selectedIndex,
          onTap: (int clickedIndex) async {
            Provider.of<SpinnerController>(context, listen: false)
                .setLoading(false);
            if (clickedIndex == 0) {
              setState(() {
                navController.selectedIndex = clickedIndex;
              });
              Navigator.of(context).popUntil((route) {
                return route.settings.name == 'menu';
              });
            } else if (clickedIndex == 1) {
              setState(() {
                navController.selectedIndex = clickedIndex;
              });

              restauranteController.getMesas(context);
              // aqui va lo de gestionar mesas
            }
            if (clickedIndex == 2) {
              setState(() {
                navController.selectedIndex = clickedIndex;
                Navigator.of(context).popUntil((route) {
                  return route.settings.name == 'menu';
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileView();
                }));
              });
            } else if (clickedIndex == 3) {
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
