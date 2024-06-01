import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';

class Pedido {
  final Map<ItemMenu, int> productos;

  Pedido({required this.productos});

  void addProduct(ItemMenu producto) {
    if (productos.containsKey(producto) && productos[producto]! >= 1) {
      productos[producto] = productos[producto]! + 1;
    } else {
      productos[producto] = 1;
    }
  }

Map<String, dynamic> toMap() {
  List<Map<String, dynamic>> productosMap = [];
  productos.forEach((producto, cantidad) {
    productosMap.add({
      'producto': producto.toMap(),
      'cantidad': cantidad,
    });
  });
  return {
    'productos': productosMap,
  };
}
  Pedido.fromMap(Map<String, dynamic> map)
      : productos = Map.fromEntries(
          (map['productos'] as List<dynamic>).map((item) => MapEntry(
            ItemMenu.fromMap(item['producto']),
            item['cantidad'],
          )),
        );

  void addProducts(ItemMenu producto, int cantidad) {
    for (int i = 0; i < cantidad; i++) {
      addProduct(producto);
    }
  }

  void deleteProduct(ItemMenu producto, String info, context) {
    if (productos.containsKey(producto) && productos[producto]! > 1) {
      productos[producto] = productos[producto]! - 1;
    } else {
      productos.remove(producto);
      if (productos.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Menu(info: info)),
        );
      }
    }
  }
}
