import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';

class Pedido {
  final Map<ItemMenu, ItemPedido> productos;

  Pedido({required this.productos});

  void addProduct(ItemMenu producto, {String comentario = '', List<Map<String, dynamic>> extras = const []}) {
    if (productos.containsKey(producto)) {
      productos[producto]!.cantidad += 1;
      productos[producto]!.comentario = comentario;
      productos[producto]!.extras = extras;
    } else {
      productos[producto] = ItemPedido(
        cantidad: 1,
        comentario: comentario,
        extras: extras,
      );
    }
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> productosMap = productos.entries.map((entry) {
      return {
        'producto': entry.key.toMap(),
        'pedido': entry.value.toMap(),
      };
    }).toList();
    return {
      'productos': productosMap,
    };
  }

Pedido.fromMap(Map<String, dynamic> map)
    : productos = Map.fromEntries(
      (map['productos'] as List<dynamic>?)?.map((item) {
        final productoMap = item['producto'] as Map<String, dynamic>;
        final pedidoMap = item['pedido'] as Map<String, dynamic>;
        final producto = ItemMenu.fromMap(productoMap);
        final pedido = ItemPedido.fromMap(pedidoMap);
        return MapEntry(producto, pedido);
      }).toList() ?? {}
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
      } else {
        productos[producto]!.cantidad = cantidad;
      }
    } else if (cantidad >= 1) {
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
