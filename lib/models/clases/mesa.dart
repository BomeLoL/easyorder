import 'package:easyorder/models/clases/pedido.dart';

class Mesa{
  final int id;
  List<Pedido> pedidos = []; 
  Mesa({required this.id, List<Pedido>? pedidos});
}