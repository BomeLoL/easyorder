import 'package:easyorder/models/clases/item_menu.dart';

class Pedido{
  final Map<ItemMenu, int> productos;

  Pedido ({
    required this.productos
  });

  void addProduct (ItemMenu producto){
    if (productos.containsKey(producto) && productos[producto]! >= 1){
      productos[producto] = productos[producto]!+1;
    }else{
      productos[producto]=1;
    }
  }
}