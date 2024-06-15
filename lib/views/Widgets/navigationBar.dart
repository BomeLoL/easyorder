import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:easyorder/views/walletView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class BarNavigation extends StatefulWidget {
  const BarNavigation({super.key, this.index});
  final index;

  @override
  State<BarNavigation> createState() => _NavigationbarState();
}

// class _NavigationbarState extends State<BarNavigation> {
//   bool confirmation = false;
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.index;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.home
//           ),
//           label: "Inicio"
//           ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.wallet
//           ),
//           label: "Billetera"
//           ),
//       ],
//       currentIndex: selectedIndex,
//       onTap: (int click){
//         setState(() {
//           selectedIndex=click;
//         });

//         if (selectedIndex==1) {
//           Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return walletView(index: selectedIndex);
//                       },
//                     ),
//                   );
//         }
//       },
//       );
//   }
// }


class _NavigationbarState extends State<BarNavigation> {
   bool confirmation = false;
   int selectedIndex = 0;
   bool isWalletSelected = false;
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<CartController, NavController>(
          builder: (context, cartController,navController,child) {
            return BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(142, 142, 142, 1),
              ),
              selectedItemColor: Colors.black,
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
                    Icons.exit_to_app,
                    size: 45.0,
                    color: Color.fromRGBO(255, 95, 4, 1),
                  ),
                  label: "Terminar sesión",
                ),
              ],
              currentIndex: navController.selectedIndex,
              onTap: (int clickedIndex) async {
                // setState(() {
                //   navController.selectedIndex = clickedIndex;
                // });
                if (clickedIndex == 2) {
                  setState(() {
                  navController.selectedIndex = clickedIndex;
                });
                  await _showConfirmationDialog(context);
                  if (confirmation == true) {
                    setState(() {
                      cartController.haPedido = false;
                      navController.selectedIndex=0;
                    });
                    // Navigator.pop(context); //este pop es que se supone cierra el menu que era la vista actual en la pila, capaz ahora se necesita popuntil porque puede ser que estes en la billetera y al darle a cerrar se hace pop es a la vista de billetera
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                } else if (clickedIndex == 0 &&
                    cartController.haPedido == false) {
                      setState(() {
                  navController.selectedIndex = clickedIndex;
                });
                  // Navigator.popUntil(context, (route) {return route.settings.name == 'menu' ;});
                  // Navigator.pushReplacement(//replacement necesario, capaz podria hacer pop de las vistas anteriores hasta la de menu y luego el replacement
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return BarcodeScannerWithOverlay();
                  //     },
                  //   ),
                  // );

                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.push(context, MaterialPageRoute(builder: (context){return BarcodeScannerWithOverlay();}));
                } else if (clickedIndex == 0 && cartController.haPedido == true) {
                  showCustomPopup(
                    context: context,
                    title: 'Finalice su estadía para escanear',
                    content: Text(
                        'Para escanear otro código, primero debes terminar tu sesión actual. Por favor, finaliza tu estadía para continuar.'),
                    actions: [
                      TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: Text(
                      'Ok',
                      style: GoogleFonts.poppins(
                          color: const Color.fromRGBO(255, 96, 4, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
      
                    ]
                  );
                } else if (clickedIndex==1 && !navController.isWalletSelected) {
                  setState(() {
                    navController.isWalletSelected=true;
                    navController.selectedIndex = clickedIndex;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return walletView();
                      },
                    ),
                  ).then((_){setState(() {
                    navController.isWalletSelected=false;
                  });});
                } else if (clickedIndex==1 && navController.isWalletSelected) {
                  setState(() {
                    navController.selectedIndex = clickedIndex;
                  });
                }
              },
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
            'Al confirmar, un mesero vendrá a atenderle para procesar el pago y ya no podrá hacer más pedidos. ¿Desea continuar?',
            textAlign: TextAlign.justify,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                        color: const Color.fromRGBO(255, 96, 4, 1),
                        fontWeight: FontWeight.bold),
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
                      backgroundColor: Color.fromRGBO(255, 96, 4, 1),
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

