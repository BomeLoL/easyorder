import 'package:easyorder/models/clases/pedido.dart';

import 'item_menu.dart';

class Factura {
  final String idRestaurante;
  List<Pedido> pedidos;

  Factura({required this.idRestaurante, required this.pedidos});

  Map<String, dynamic> toMap() {
    // Exportar
    return {
      'idRestaurante': idRestaurante,
      'pedidos': pedidos
          .map((item) => item.toMap())
          .toList(), // Convertir cada pedido a un mapa
    };
  }

  Factura.fromMap(Map<String, dynamic> map) // Importar
      : idRestaurante = map['idRestaurante'],
        pedidos = List<Pedido>.from(map['pedidos'].map((item) =>
            ItemMenu.fromMap(item))); // Convertir cada mapa en un ItemMenu
}
