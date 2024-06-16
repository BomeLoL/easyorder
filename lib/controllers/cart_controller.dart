
import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:flutter/foundation.dart';

class CartController extends ChangeNotifier{
  Pedido _pedido = Pedido(productos: []);
  bool haPedido = false; //cambiar esto a algo mejor para el siguiente sprint

  Pedido get pedido => _pedido;

  set pedido(Pedido nuevoPedido) {
    _pedido = nuevoPedido;
    notifyListeners();
  }

  void addProduct(ItemMenu producto, {String comentario = '', List<String> extras = const []}) {
    _pedido.addProduct(producto, comentario: comentario);
    notifyListeners();
  }
  void addProducts(ItemMenu producto, int cantidad, {String comentario = '', List<String> extras = const []}) {
 _pedido.addProducts(producto, cantidad, comentario: comentario, extras: extras);
    notifyListeners();
}

itemPedido? getProductIfExists(ItemMenu producto, {String comentario = '', List<String> extras = const []}) {
    return _pedido.getProductIfExists(producto, comentario: comentario, extras: extras);
  }


void deleteProduct(ItemMenu producto, String info, int isPedido, {String comentario = '', List<String> extras = const []}) {
    _pedido.deleteProduct(producto, info, isPedido, comentario: comentario, extras: extras);
    notifyListeners();
  }
  void updateProductQuantity(ItemMenu producto, int cantidad, {String comentario = '', List<String> extras = const []}) {
    _pedido.updateProductQuantity(producto, cantidad, comentario: comentario);
    notifyListeners();
  }

  void updateComment(ItemMenu producto, String comentarioOriginal, String comentarioNuevo){
    _pedido.updateComment(producto, comentarioOriginal, comentarioNuevo);
  }

  int getOneProductQuantity(ItemMenu producto, {String comentario = '', List<String> extras = const []}) {
    return _pedido.getOneProductQuantity(producto, comentario: comentario);
  }
int totalCantidad() {
   return _pedido.totalCantidad();
 } 
  
  void deleteProducts(itemPedido? producto, String info, context, int isPedido) {
  _pedido.deleteProducts(producto, info, isPedido);
  notifyListeners();
}
  double getTotalAmount() {
   return _pedido.getTotalAmount();
   
 }

  bool isCommented(int id) {
    return _pedido.isCommented(id);
  }

  int getQuantityByProduct(int id) {
    return _pedido.getQuantityByProduct(id);
  }

}

