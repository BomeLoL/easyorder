import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/edit_categories.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';

class CategoriesController {
  Future<void> getCategoriasfromBD(context, menu, tipo) async {
    var categorias;
    categorias = await MongoDatabase.getCategorias();

    if (categorias.isNotEmpty && tipo == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return EditCategories(
              menu: menu,
              tipo: 0,
              categoria: categorias,
            );
          },
        ),
      );
    } else if (categorias.isNotEmpty && tipo == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return EditCategories(
              menu: menu,
              tipo: 1,
              categoria: categorias,
            );
          },
        ),
      );
    }
  }

  void editarCategoria(String newCategory, Map<String, bool> productos,List cambiar, String oldCategory, Menu menu, List categories) async {

    //poner en string vacio las que se quedaron sin categoria
    cambiar.forEach((producto) {
      print(
          "Se cambia a categoria vacio el producto ${producto.nombreProducto}");
      producto.categoria = "";
    });

    //cambiar la categoria de los productos seleccionados
    productos.forEach((nombreProducto, estaSeleccionado) {
      if (estaSeleccionado) {
        menu.itemsMenu.forEach((producto) {
          if (producto.nombreProducto == nombreProducto) {
            print("Actualizando ${producto.nombreProducto} a la categoría $newCategory");
            producto.categoria = newCategory;
          }
        });
      }
    });

    //cambiar el nombre de la categoria
    for (int i = 0; i < categories.length; i++) {
      if (categories[i] == oldCategory) {
        categories[i] = newCategory;
      }
    }

    MongoDatabase.actualizarMenu(menu);

    MongoDatabase.actualizaCategorias(categories);


  }


}
