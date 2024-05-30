import 'package:easyorder/models/clases/mesa.dart';

class Restaurante {
  final String id;
  String nombre; 
  List<Mesa> mesas;
  List<Map<String, dynamic>> comentarios = []; 
  

  Restaurante({required this.id, required this.nombre, required this.mesas, List<Map<String, dynamic>>? comentarios });


  Map<String, dynamic> toMap(){  //Exportar
    return{
     '_id': id ,
     'nombre': nombre,
     'mesas': mesas,
     'comentarios': comentarios, 
   };
 }

  Restaurante.fromMap(Map<String, dynamic> map) //Importar
  : id = map['_id'],
  nombre = map['nombre'],
  mesas = map['mesas'],
  comentarios = map['comentarios'];

}