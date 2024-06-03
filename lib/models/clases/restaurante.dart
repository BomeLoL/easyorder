import 'package:easyorder/models/clases/mesa.dart';

class Restaurante {
  final String id;
  String nombre; 
  List<Mesa> mesas;
  List<Map<String, dynamic>> comentarios; 


  Restaurante({required this.id, required this.nombre, required this.mesas, required this.comentarios});


  Map<String, dynamic> toMap() { //Exportar
    List<Map<String, dynamic>> mesasMap = mesas.map((mesa) => mesa.toMap()).toList();
    return {
      '_id': id,
      'nombre': nombre,
      'mesas': mesasMap,
      'comentarios': comentarios,
    };
  }


  Restaurante.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        nombre = map['nombre'],
        mesas = (map['mesas'] as List<dynamic>)
            .map((item) => Mesa.fromMap(item))
            .toList(),
        comentarios = List<Map<String, dynamic>>.from(map['comentarios']);
}