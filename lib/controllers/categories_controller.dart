import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';


class CategoriesController {

  void editarCategoria (String newCategory, Map<String, bool> productos, List cambiar) async {
      // Implementa la lógica para actualizar el nombre de la categoría
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print(productos);
      print("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      cambiar.forEach((producto) {print("Se cambia a categoria vacio el producto ${producto.nombreProducto}");});
  productos.forEach((nombreProducto, estaSeleccionado) {
    if (estaSeleccionado) {
      // Lógica para actualizar la categoría del producto
      // Por ejemplo, podrías actualizar en una base de datos o en una lista en memoria
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print('Actualizando $nombreProducto a la categoría $newCategory');

      
    }
  });
  }
  
}