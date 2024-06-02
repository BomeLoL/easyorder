import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/mesa.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';



Future<bool> RevisarBd(barcode, context) async {
  String infoQr = barcode.first.displayValue;
  // bool continuar=false;
  // bool error=false;
  try {
    var ids = infoQr.split(",");
    String idRestaurante=ids[0];
    var restaurante;
    var menu;
    var j;
    String idMesa=ids[1].trim();
    restaurante= await MongoDatabase.getRestaurante(idRestaurante);
    menu= await MongoDatabase.getMenu(idRestaurante);
    if (restaurante==null) {//no existe el restaurante
      barcode.removeAt(0);
      return false;
      // return [continuar, error];
    } else if (restaurante!=null) { //si existe 
      bool existeMesa = false;
      for (var i = 0; i < restaurante.mesas.length; i++) {//se ve si existe la mesa
         
        if (restaurante.mesas[i].id == int.parse(idMesa)) {
          j=i;
          existeMesa = true;
          break;
        }
      }

      if (existeMesa) { // el restaurante si posee la mesa escaneada
       // if (restaurante.mesa[idMesa].pedidos.length==0) {//la mesa no esta ocupada, se va al menu normal      
       // Obtener la instancia de CartController
      CartController cartController = Provider.of<CartController>(context, listen: false);

        Pedido pedidoVacio = Pedido(productos: {});
        cartController.pedido = pedidoVacio;
                  
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return             
            MenuView(info: restaurante.id, restaurante: restaurante,menu: menu,);
            }));
       // }
        //else { //la mesa esta ocupada

       // }
      } else { // no posee la mesa escaneada
      }
      // return [continuar=true, error];
      return true;
    }
    
    
  } catch (e) {
    // return [continuar=true,error=true];
    return false;
  }
  
  // return [continuar=true,error=true];
  return false;

}