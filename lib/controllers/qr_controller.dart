import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/menu.dart';
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

      if (existeMesa) { // el restaurante si posee la mesa escaneada
       // if (restaurante.mesa[idMesa].pedidos.length==0) {//la mesa no esta ocupada, se va al menu normal      
       // Obtener la instancia de CartController
      CartController cartController = Provider.of<CartController>(context, listen: false); //aqui salia la excepcion
//        bool exist = true;
// Llamar al setter pedido para establecer el nuevo pedido
//        try{
//        Pedido nuevoPedido = restaurante.mesas[j].pedidos[0];
//        }catch(e){exist = false;}
//        if (exist == true){
//        Pedido nuevoPedido = restaurante.mesas[j].pedidos[0];
//        cartController.pedido = nuevoPedido;}
//        else{
        Pedido pedidoVacio = Pedido(productos: {});
        cartController.pedido = pedidoVacio;
//        }          
        navigateToMenu(restaurante, menu, idMesa); //quito el context para intentar arreglar error
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
  // void navigateToMenu(BuildContext context, Restaurante restaurante, Menu menu, String idMesa ){
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) { //maybe push 
  //           return   
  //           MenuView(info: restaurante.id, restaurante: restaurante,menu: menu, idMesa: int.parse(idMesa));
  //           },
  //           settings: const RouteSettings(name: 'menu'),
  //           ));
  // } //se comento para ver si funcionaba la solucion de abajo 

  void navigateToMenu(Restaurante restaurante, Menu menu, String idMesa) {
  if (context != null) {
    Navigator.pushReplacement(
      context!,
      MaterialPageRoute(
        builder: (context) {
          return MenuView(
            info: restaurante.id,
            restaurante: restaurante,
            menu: menu,
            idMesa: int.parse(idMesa),
          );
        },
        settings: const RouteSettings(name: 'menu'),
      ),
    );
  }
}
}
