import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';


class QrController {

  Future<int> revisarBd(barcode, context) async {
  String infoQr = barcode.first.displayValue;

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
      CartController cartController = Provider.of<CartController>(context, listen: false);
//        bool exist = true;
// Llamar al setter pedido para establecer el nuevo pedido
//        try{
//        Pedido nuevoPedido = restaurante.mesas[j].pedidos[0];
//        }catch(e){exist = false;}
//        if (exist == true){
//        Pedido nuevoPedido = restaurante.mesas[j].pedidos[0];
//        cartController.pedido = nuevoPedido;}
//        else{
        Pedido pedidoVacio = Pedido(productos: []);
        cartController.pedido = pedidoVacio;
//        }          
        navigateToMenu(context, restaurante, menu, idMesa);
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
  void navigateToMenu(BuildContext context, Restaurante restaurante, Menu menu, String idMesa ){
    Future.microtask(() {
    MenuEditController _menuEditController = Provider.of<MenuEditController>(context, listen: false);
    
    // Manejo de errores para asegurarse de que el menú se establece correctamente
    try {
      _menuEditController.menu = menu;
    } catch (e) {
      print("Error al establecer el menú en MenuEditController: $e");
      // Manejar el error adecuadamente, por ejemplo, navegando a una pantalla de error o mostrando un mensaje
      return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return   
            MenuView(info: restaurante.id, restaurante: restaurante, idMesa: int.parse(idMesa));
            },
            settings: const RouteSettings(name: 'menu'),
            ));
    });
    
  }
}
