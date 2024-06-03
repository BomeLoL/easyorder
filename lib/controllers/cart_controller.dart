
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/foundation.dart';

class CartController extends ChangeNotifier{
  Pedido _pedido = Pedido(productos: {});
  
  Pedido get pedido => _pedido;

  set pedido(Pedido nuevoPedido) {
    _pedido = nuevoPedido;
    notifyListeners();
  }

  void addProduct(ItemMenu producto) {
    _pedido.addProduct(producto);
    notifyListeners();
  }
  void addProducts(ItemMenu producto, int cantidad) {
 _pedido.addProducts(producto, cantidad);
    notifyListeners();
}
void deleteProduct(ItemMenu producto, String info, context, Restaurante restaurante, Menu menu, int idMesa) {
    _pedido.deleteProduct(producto, info, context, restaurante, menu, idMesa);
    notifyListeners();
  }
}