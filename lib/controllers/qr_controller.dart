import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/menu.dart';



Future<bool> RevisarBd(barcode, context) async {
  String infoQr = barcode.first.displayValue;
  try {
    var ids = infoQr.split(",");
    String idRestaurante=ids[0];
    var restaurante;
    String idMesa=ids[1].trim();
    restaurante= await MongoDatabase.getRestaurante(idRestaurante);
    if (restaurante==null) {//no existe el restaurante
      barcode.removeAt(0);
      return false;
    } else if (restaurante!=null) { //si existe 
      bool existeMesa = false;
      for (var i = 0; i < restaurante.mesas.length; i++) {//se ve si existe la mesa
         
        if (restaurante.mesas[i].id == int.parse(idMesa)) {
          existeMesa = true;
          break;
        }
      }

      if (existeMesa) { // el restaurante si posee la mesa escaneada
       // if (restaurante.mesa[idMesa].pedidos.length==0) {//la mesa no esta ocupada, se va al menu normal
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return 
            
            
            Menu(info: restaurante.nombre);
            }));
       // }
        //else { //la mesa esta ocupada

       // }
      } else { // no posee la mesa escaneada
      }
      return true;
    }
    
    
  } catch (e) {
    
  }
  
  return false;

}