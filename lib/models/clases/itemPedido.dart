import 'package:easyorder/models/clases/item_menu.dart';
import 'package:flutter/foundation.dart';

class itemPedido {
  final ItemMenu producto;
  int cantidad;
  String? comentario;
  List<String> extras;

  itemPedido({
    required this.producto,
    required this.cantidad,
    this.comentario,
    this.extras = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is itemPedido &&
        other.producto == producto &&
        other.cantidad == cantidad &&
        other.comentario == comentario &&
        listEquals(other.extras, extras); // Comparar listas usando listEquals de flutter
  }

  @override
  int get hashCode =>
      producto.hashCode ^
      cantidad.hashCode ^
      (comentario?.hashCode ?? 0) ^
      extras.hashCode; // Agregar extras al cálculo del hashCode

  Map<String, dynamic> toMap() {
    return {
      'producto': producto.toMap(),
      'cantidad': cantidad,
      'comentario': comentario,
      'extras': extras,
    };
  }

  itemPedido.fromMap(Map<String, dynamic> map)
      : producto = ItemMenu.fromMap(map['producto']),
        cantidad = map['cantidad'],
        comentario = map['comentario'] ?? '',
        extras = List<String>.from(map['extras'] ?? []);
}