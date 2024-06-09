class ItemPedido {
  int cantidad;
  String comentario;
  List<Map<String, dynamic>> extras;

  ItemPedido({
    required this.cantidad,
    this.comentario = '',
    this.extras = const [], 
  });

  Map<String, dynamic> toMap() {
    return {
      'cantidad': cantidad,
      'comentario': comentario,
      'extras': extras.map((extra) => Map<String, dynamic>.from(extra)).toList(),
    };
  }

  ItemPedido.fromMap(Map<String, dynamic> map)
      : cantidad = map['cantidad'],
        comentario = map['comentario'] ?? '', 
        extras = (map['extras'] as List).map((extra) => Map<String, dynamic>.from(extra)).toList();
}
