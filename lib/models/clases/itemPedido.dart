class itemPedido {
  int cantidad;
  String comentario;
  List<String> extras;

  itemPedido({
    required this.cantidad,
    this.comentario = '',
    this.extras = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'cantidad': cantidad,
      'comentario': comentario,
      'extras': extras,
    };
  }

  itemPedido.fromMap(Map<String, dynamic> map)
      : cantidad = map['cantidad'],
        comentario = map['comentario'] ?? '',
        extras = List<String>.from(map['extras'] ?? []);
}