import 'package:easyorder/models/clases/pedido.dart';

class Mesa{
  final int id;
  List<Pedido> pedidos; 
  Mesa({required this.id, required this.pedidos});


Map<String, dynamic> toMap() {
  List<Map<String, dynamic>> pedidosMap = [];
  if (pedidos.isNotEmpty) {
    pedidosMap = pedidos.map((pedido) => pedido.toMap()).toList();
  }
  return {
    'id': id,
    'pedidos': pedidosMap,
  };
}
Mesa.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        pedidos = (map['pedidos'] as List<dynamic>?)?.map((item) => Pedido.fromMap(item)).toList() ?? [];

}