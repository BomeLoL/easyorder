
import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/foundation.dart';

class CartController extends ChangeNotifier{
  Pedido _pedido = Pedido(productos: []);
  bool haPedido = false; //cambiar esto a algo mejor para el siguiente sprint

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

itemPedido? getProductIfExists(ItemMenu producto, {String? comentario, List<String> extras = const []}) {
    return _pedido.getProductIfExists(producto, comentario: comentario, extras: extras);
  }


void deleteProduct(ItemMenu producto, String info, context, int isPedido, {String? comentario, List<String> extras = const []}) {
    _pedido.deleteProduct(producto, info, context, isPedido, comentario: comentario, extras: extras);
    notifyListeners();
  }
  void updateProductQuantity(ItemMenu producto, int cantidad, {String? comentario, List<String> extras = const []}) {
    _pedido.updateProductQuantity(producto, cantidad);
    notifyListeners();
  }

  int getOneProductQuantity(ItemMenu producto) {
    return _pedido.getOneProductQuantity(producto);
  }
int totalCantidad() {
   return _pedido.totalCantidad();
 } 
//  
  void deleteProducts(itemPedido? producto, String info, context, int isPedido) {
  _pedido.deleteProducts(producto, info, context, isPedido);
  notifyListeners();
}
  double getTotalAmount() {
   return _pedido.getTotalAmount();
   
 }
}

