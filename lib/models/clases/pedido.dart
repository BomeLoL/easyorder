import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class Pedido {
  final List<itemPedido> productos;

  Pedido({required this.productos});

  itemPedido? getProductIfExists(ItemMenu producto,
      {String comentario = '', List<String> extras = const []}) {
    return productos.firstWhereOrNull(
      (item) =>
          item.producto == producto &&
          item.comentario == comentario &&
          listEquals(item.extras, extras),
    );
  }

  void addProduct(ItemMenu producto,
      {String comentario = '', List<String> extras = const []}) {
    var existingProduct =
        getProductIfExists(producto, comentario: comentario, extras: extras);
    if (existingProduct != null) {
      existingProduct.cantidad += 1;
    } else {
      productos.add(
        itemPedido(
          producto: producto,
          cantidad: 1,
          comentario: comentario,
          extras: extras,
        ),
      );
    }
  }

  bool existingProduct(ItemMenu producto,
      {String? comentario, List<String> extras = const []}) {
    return productos.any(
      (item) =>
          item.producto == producto &&
          item.comentario == comentario &&
          listEquals(item.extras, extras),
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> productosMap = productos.map((producto) {
      return producto.toMap();
    }).toList();
    return {
      'productos': productosMap,
    };
  }

  Pedido.fromMap(Map<String, dynamic> map)
      : productos = (map['productos'] as List<dynamic>)
            .map((item) => itemPedido.fromMap(item))
            .toList();

  void addProducts(ItemMenu producto, int cantidad,
      {String comentario = '', List<String> extras = const []}) {
    for (int i = 0; i < cantidad; i++) {
      addProduct(producto, comentario: comentario, extras: extras);
    }
  }

  void deleteProduct(ItemMenu producto, String info,
      {String comentario = '', List<String> extras = const []}) {
    var existingProduct =
        getProductIfExists(producto, comentario: comentario, extras: extras);
    if (existingProduct != null && existingProduct.cantidad > 1) {
      existingProduct.cantidad -= 1;
    } else {
      deleteProducts(existingProduct, info);
    }
  }

  void updateProductQuantity(ItemMenu producto, int cantidad,
      {String comentario = '', List<String> extras = const []}) {
    var existingProduct = getProductIfExists(producto, comentario: comentario);
    if (existingProduct != null) {
      if (cantidad == 0) {
        productos.remove(existingProduct);
      } else {
        existingProduct.cantidad = cantidad;
      }
    } else if (cantidad >= 1) {
      addProducts(producto, cantidad, comentario: comentario, extras: extras);
    }
  }

  void updateComment(
      ItemMenu producto, String comentarioOriginal, String comentarioNuevo) {
    var existingProduct =
        getProductIfExists(producto, comentario: comentarioOriginal);
    existingProduct!.comentario = comentarioNuevo;
  }

  void deleteProducts(
      itemPedido? producto, String info) {
    productos.remove(producto);
  }

  int totalCantidad() {
    int total = 0;
    productos.forEach(
      (producto) {
        total += producto.cantidad;
      },
    );
    return total;
  }

  int getOneProductQuantity(ItemMenu producto,
      {String comentario = '', List<String> extras = const []}) {
    return getProductIfExists(producto, comentario: comentario)?.cantidad ?? 0;
  }

  double getTotalAmount() {
    double total = 0;
    productos.forEach((productoMenu) {
      total += productoMenu.cantidad * productoMenu.producto.precio;
    });
    String totalFormateado =
        total.toStringAsFixed(2); // Limita a 2 posiciones decimales
    return double.parse(totalFormateado);
  }

  bool isCommented(int id) {
    bool _isCommented = false;
    productos.forEach((productoMenu) {
      if (productoMenu.producto.id == id && productoMenu.comentario != '') {
        _isCommented = true;
      }
      ;
    });
    return _isCommented;
  }
  int getQuantityByProduct(int id) {
    int cantidad = 0;
    productos.forEach((productoMenu) {
      if (productoMenu.producto.id == id) {
        cantidad += productoMenu.cantidad;
      };
    });
    return cantidad;
  }

  void agregarProductos(List<itemPedido> nuevosProductos) {
    productos.addAll(nuevosProductos);
  }

}