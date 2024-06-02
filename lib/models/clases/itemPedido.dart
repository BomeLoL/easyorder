class itemPedido{

  int cantidad;
  String comentario;
  List<String> extras;

  itemPedido ({
    required this.cantidad,
    this.comentario = '',
    this.extras = const [],
  });

}