import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';

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

  void addProducts(ItemMenu producto, int cantidad) {
    for (int i = 0; i < cantidad; i++) {
      addProduct(producto);
    }
  }
  void deleteProduct(ItemMenu producto, String info, context, int isPedido) {
    if (productos.containsKey(producto) && productos[producto]!.cantidad > 1) {
      productos[producto]!.cantidad -= 1;
    } else {
      productos.remove(producto);
      if (productos.isEmpty && isPedido == 0) {
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => Menu(info: info)),
        );
      }
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
 // void deleteProduct(ItemMenu producto, String info, context) {
 //   if (productos.containsKey(producto) && productos[producto]! > 1) {
 //     productos[producto] = productos[producto]! - 1;
 //   } else {
 //     productos.remove(producto);
 //     if (productos.isEmpty) {
 //       Navigator.push(
 //         context,
 //         MaterialPageRoute(builder: (context) => Menu(info: info)),
 //       );
 //     }
 //   }
 // }
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
}
