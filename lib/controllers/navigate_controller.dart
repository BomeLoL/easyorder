import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigateController {
  void navigateToMenu(BuildContext context, Restaurante restaurante, Menu menu, String idMesa, String usertype) {
    Future.microtask(() {
      MenuEditController _menuEditController = Provider.of<MenuEditController>(context, listen: false);

      // Manejo de errores para asegurarse de que el menú se establece correctamente
      try {
        _menuEditController.menu = menu;
      } catch (e) {
        print("Error al establecer el menú en MenuEditController: $e");
        // Manejar el error adecuadamente, por ejemplo, navegando a una pantalla de error o mostrando un mensaje
        return;
      }

      if (usertype == "Comensal"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MenuView(info: restaurante.id, restaurante: restaurante, idMesa: int.parse(idMesa));
      }, settings: const RouteSettings(name: 'menu')));
    } else if (usertype == "Restaurante"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MenuView(info: restaurante.id, restaurante: restaurante, idMesa: 1);
      }, settings: const RouteSettings(name: 'menu')));
    }


    });
  }
  
}
