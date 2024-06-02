
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:flutter/foundation.dart';

class CartController extends ChangeNotifier{
  Pedido _pedido = Pedido(productos: {});

  Pedido get pedido => _pedido;

  void addProduct(ItemMenu producto) {
    _pedido.addProduct(producto);
    notifyListeners();
  }
  void addProducts(ItemMenu producto, int cantidad) {
 _pedido.addProducts(producto, cantidad);
    notifyListeners();
}
void deleteProduct(ItemMenu producto, String info, context, isPedido) {
    _pedido.deleteProduct(producto, info, context, isPedido);
    notifyListeners();
  }
  void updateProductQuantity(ItemMenu producto, int cantidad) {
    _pedido.updateProductQuantity(producto, cantidad);
    notifyListeners();
  }

  int getOneProductQuantity(ItemMenu producto) {
    return _pedido.getOneProductQuantity(producto);
  }
 int totalCantidad() {
    return _pedido.totalCantidad();
  } 
  
  void deleteProducts(ItemMenu producto, String info, context, int isPedido) {
  _pedido.deleteProducts(producto, info, context, isPedido);
  notifyListeners();
}
  double getTotalAmount() {
   return _pedido.getTotalAmount();
   
 }

}

