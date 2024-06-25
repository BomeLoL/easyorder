import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/navigationBar/navigationBarClientLogged.dart';
import 'package:easyorder/views/Widgets/navigationBar/navigationBarClientUnLogged.dart';
import 'package:easyorder/views/Widgets/navigationBar/navigationBarRestaurant.dart';
import 'package:easyorder/views/screens/detalleAdmin/detalleAdmin.dart';
import 'package:easyorder/views/screens/menu/layouts/cart_summary.dart';
import 'package:easyorder/views/screens/menu/layouts/categories_view.dart';
import 'package:easyorder/views/screens/menu/layouts/menu_header.dart';
import 'package:easyorder/views/screens/menu/layouts/products_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MenuView extends StatefulWidget {
  const MenuView({
    super.key,
    required this.info,
    required this.restaurante,
    required this.idMesa,
  });

  final String info;
  final Restaurante restaurante;
  final int idMesa;

  @override
  State<MenuView> createState() => _MenuState();
}

class _MenuState extends State<MenuView> {
  String nombreRes = "";

  @override
  void initState() {
    super.initState();
    nombreRes = widget.restaurante.nombre;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, userController, child) {
      return PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(),
            body: Background_image(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        right: 16,
                        left: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: kToolbarHeight +
                                  MediaQuery.of(context).size.height * 0.03),
                          MenuHeader(),
                          Gap(15),
                          CategoriesView(),
                          SizedBox(
                            height: 10,
                          ),
                          if (userController.usuario?.usertype == 'Restaurante')
                            _buildDivider(),
                          ProductsList(nombreRes: nombreRes, restauranteId: widget.restaurante.id),
                          if (userController.usuario?.usertype == 'Restaurante')
                            _buildAdminAddProductButton()
                        ],
                      ),
                    ),
                  ),
                  if (userController.usuario?.usertype == 'Comensal' ||
                      userController.usuario == null)
                    CartSummary(nombreRes: nombreRes, restaurante: widget.restaurante, idMesa: widget.idMesa)
                ],
              ),
            ),
            bottomNavigationBar: () {
              if (userController.usuario == null) {
                return BarNavigationClientUnlogged(
                    idMesa: widget.idMesa,
                    info: widget.info,
                    restaurante: widget.restaurante);
              } else if (userController.usuario != null) {
                if (userController.usuario?.usertype == "Comensal") {
                  return BarNavigationClientLogged(
                      idMesa: widget.idMesa,
                      info: widget.info,
                      restaurante: widget.restaurante);
                } else if (userController.usuario?.usertype == "Restaurante") {
                  return BarNavigationRestaurant();
                }
              }
            }()),
      );
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        nombreRes,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: primaryColor.withOpacity(0.3),
          thickness: 2,
        ),
        Gap(10),
        Text(
          'Productos',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Gap(10),
      ],
    );
  }

  Widget _buildAdminAddProductButton() {
    return Column(
      children: [
        Gap(10),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final tester = await MongoDatabase.Test();
              if (tester == false) {
                // ignore: use_build_context_synchronously
                dbErrorDialog(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return detalleAdmin(idRestaurante: widget.restaurante.id);
                    },
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Text(
              'Agregar un producto',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Gap(10),
      ],
    );
  }

}
