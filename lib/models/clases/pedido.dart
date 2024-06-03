import 'dart:ffi';

import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';

class Pedido {
  final Map<ItemMenu, itemPedido> productos;

  Pedido({required this.productos});

  void addProduct(ItemMenu producto, {String comentario = '', List<String> extras = const []}) {
    if (productos.containsKey(producto)) {
      productos[producto]!.cantidad += 1;
      productos[producto]!.comentario = comentario;
      productos[producto]!.extras = extras;
    } else {
      productos[producto] = itemPedido(
        cantidad: 1,
        comentario: comentario,
        extras: extras,
      );
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

  void deleteProduct(ItemMenu producto, String info, context, int isPedido) {
    if (productos.containsKey(producto) && productos[producto]!.cantidad > 1) {
      productos[producto]!.cantidad -= 1;
    } else {
      deleteProducts(producto, info, context, isPedido);
    }
    }
  
  void updateProductQuantity(ItemMenu producto, int cantidad) {

    if (productos.containsKey(producto)) {
      if (cantidad == 0) {
        productos.remove(producto);
      }else {
      productos[producto]!.cantidad = cantidad;
      }    
  }else if (cantidad >= 1){
    addProducts(producto, cantidad);
  }
  }

void deleteProducts(ItemMenu producto, String info, context, int isPedido) {
  productos.remove(producto);
}

  int totalCantidad() {
    int total = 0;
    productos.forEach((key, productoPedido) {
      total += productoPedido.cantidad;
    });
    return total;
  }

  int getOneProductQuantity(ItemMenu producto) {
  return productos[producto]?.cantidad ?? 0;
}

  double getTotalAmount() {
    double total = 0;
    productos.forEach((productoMenu, productoPedido) {
      total += productoPedido.cantidad * productoMenu.precio;
    });
    String totalFormateado = total.toStringAsFixed(2); // Limita a 2 posiciones decimales
    return double.parse(totalFormateado); 
  }


}

