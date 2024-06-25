import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuHeader extends StatefulWidget {
  const MenuHeader({super.key});

  @override
  State<MenuHeader> createState() => _MenuHeaderState();
}

class _MenuHeaderState extends State<MenuHeader> {
  @override
  Widget build(BuildContext context) {

    MenuEditController menuEditController =
        Provider.of<MenuEditController>(context, listen: false);
    CategoriesController categoriesController =
        Provider.of<CategoriesController>(context, listen: false);

    return Consumer<UserController>(builder: (context, userController, child) {
      if (userController.usuario?.usertype == 'Restaurante') {
        return Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                'Categorías',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            //crear categoria
            IconButton(
              onPressed: () async {
                final tester = await MongoDatabase.Test();
                if (tester == false) {
                  // ignore: use_build_context_synchronously
                  dbErrorDialog(context);
                } else {
                  categoriesController.getCategoriasfromBD(
                      context, menuEditController.menu!, 0);
                }
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              style: IconButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7))),
            ),
            //editar categoria
            IconButton(
              onPressed: () async {
                final tester = await MongoDatabase.Test();
                if (tester == false) {
                  // ignore: use_build_context_synchronously
                  dbErrorDialog(context);
                } else {
                  categoriesController.getCategoriasfromBD(
                      context, menuEditController.menu!, 1);
                }
              },
              style: IconButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7))),
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            //eliminar categoria
            IconButton(
              onPressed: () async {
                final tester = await MongoDatabase.Test();
                if (tester == false) {
                  // ignore: use_build_context_synchronously
                  dbErrorDialog(context);
                } else {
                  categoriesController.getCategoriasfromBD(
                      context, menuEditController.menu!, 2);
                }
              },
              style: IconButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7))),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ],
        );
      } else {
        return Text("Menú del Restaurante", style: titleStyle);
      }
    });
  }
}
