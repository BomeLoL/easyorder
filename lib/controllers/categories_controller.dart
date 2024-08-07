import 'package:easyorder/models/clases/menu.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/screens/categorias/edit_categories.dart';


class CategoriesController extends ChangeNotifier {
  List<String>? _categories;

  List<String>? get categories => _categories;

  Future<void> getCategoriasfromBD(context, menu, tipo) async {
    var categorias;
    categorias = await MongoDatabase.getCategorias(menu.idRestaurante);

    
      _categories = categorias;
      notifyListeners();

      if (tipo == 1 || tipo == 0 || tipo == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditCategories(
                menu: menu,
                tipo: tipo,
                categoria: categorias,
              );
            },
          ),
        );
      }
  }

  void editarCategoria(String newCategory, Map<String, bool> productos,
      List cambiar, String oldCategory, Menu menu, List<String> categories) async {
    //poner en string de otros las que se quedaron sin categoria
    cambiar.forEach((producto) {
      producto.categoria = "";
    });

    //cambiar la categoria de los productos seleccionados
    productos.forEach((nombreProducto, estaSeleccionado) {
      if (estaSeleccionado) {
        menu.itemsMenu.forEach((producto) {
          if (producto.nombreProducto == nombreProducto) {
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
    MongoDatabase.actualizaCategorias(categories, menu.idRestaurante);
    _categories = categories;
    notifyListeners();
  }

  void crearCategoria(String newCategory, Map<String, bool> productos,
      Menu menu, List<String> categories) async {
    bool hayProductoSeleccionado = false;
    //cambiar la categoria de los productos seleccionados
    productos.forEach((nombreProducto, estaSeleccionado) {
      if (estaSeleccionado) {
        hayProductoSeleccionado = true;
        menu.itemsMenu.forEach((producto) {
          if (producto.nombreProducto == nombreProducto) {
            producto.categoria = newCategory;
          }
        });
      }
    });
    //añadir categoria nueva
    categories.add(newCategory);
    if (hayProductoSeleccionado == true) {
      MongoDatabase.actualizarMenu(menu);
    }

    MongoDatabase.actualizaCategorias(categories, menu.idRestaurante);

    _categories = categories;
    notifyListeners();
  }

  void eliminarCategoria(String deleteCategory, Map<String, bool> productos,Menu menu, List<String> categories) async {

    //cambiar a vacio la categoria de los productos seleccionados
    productos.forEach((nombreProducto, estaSeleccionado) {
      if (estaSeleccionado) {
        menu.itemsMenu.forEach((producto) {
          if (producto.nombreProducto == nombreProducto) {
            producto.categoria = "";
          }
        });
      }
    });

    //eliminar la categoria de la lista
    categories.removeWhere((item) => item==deleteCategory);

    //actualizamos en BD
    MongoDatabase.actualizaCategorias(categories, menu.idRestaurante);
    MongoDatabase.actualizarMenu(menu);

    _categories = categories;
    notifyListeners();

  }
}
