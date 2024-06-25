import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/restaurante_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/views/screens/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigateController {
  void navigateToMenu(BuildContext context, Restaurante restaurante, Menu menu, String idMesa, String usertype) {
    Future.microtask(() {
      MenuEditController _menuEditController = Provider.of<MenuEditController>(context, listen: false);
      CategoriesController _categoriesController=Provider.of<CategoriesController>(context, listen: false);

      RestauranteController _restauranteController = Provider.of<RestauranteController>(context, listen: false);

      Provider.of<SpinnerController>(context, listen: false).setLoading(false);
      try {
        _restauranteController.restaurante=restaurante;
        _menuEditController.menu = menu;
        _categoriesController.getCategoriasfromBD(context, menu, 3);
        _menuEditController.selectedCategoria="Todo";
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
