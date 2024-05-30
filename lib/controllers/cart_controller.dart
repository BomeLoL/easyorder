
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
}