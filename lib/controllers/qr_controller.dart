import 'package:easyorder/controllers/navigate_controller.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/menu/menu.dart';
import 'package:provider/provider.dart';


class QrController {

  BuildContext? context; //nuevo para intentar arreglar un error que salia en el debug, el error solo aparece como excepcion en el debud

  Future<int> revisarBd(barcode, context) async {
  String infoQr = barcode.first.displayValue;
  this.context = context; //nuevo para intentar arreglar un error que salia en el debug

  try {
    bool? tester = await MongoDatabase.Test();
    if (tester == true){
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
      return 1;
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

      if (existeMesa) { 
        CartController cartController = Provider.of<CartController>(context, listen: false);
        Pedido pedidoVacio = Pedido(productos: []);
        cartController.pedido = pedidoVacio;

        CheckController checkController = Provider.of<CheckController>(context, listen: false);
        Pedido? pedido = await MongoDatabase.consolidarPedidos(idRestaurante, int.parse(idMesa));

        if (pedido!= null){
          if (pedido.productos.isEmpty){
            cartController.haPedido = false;
          }else{
            cartController.haPedido = true;
          }
          checkController.pedido = pedido;
        }

//        }          
        NavigateController().navigateToMenu(context,restaurante, menu, idMesa,"Comensal"); //quito el context para intentar arreglar error
       // }

      } else { // no posee la mesa escaneada
        return 1;
      }
      // return [continuar=true, error];
      return 0;
    }
    
    }else{
      return 2;
    }
  } catch (e) {
    // return [continuar=true,error=true];
    return 1;
  }
  
  // return [continuar=true,error=true];
  return 1;

}

}

