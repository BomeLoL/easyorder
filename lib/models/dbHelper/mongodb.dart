import 'dart:async';

import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/mesa.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, coleccion_restaurante, coleccion_menu, coleccion_test;
  // ignore: unused_field
  static Timer? _connectionCheckTimer;
  static String? MONGO_URL = dotenv.env["MONGO_URL"];
  static connect() async{
    
    db = await Db.create(MONGO_URL!); 
    await db.open();
    coleccion_menu = db.collection(CMenu);
    coleccion_restaurante = db.collection(CRestaurante);
    coleccion_test = db.collection(Ctest);
  }

static Future<Restaurante?> getRestaurante(String id) async {
  try {
    final restauranteMap = await coleccion_restaurante.findOne({'_id': id});


    if (restauranteMap != null) {
      Restaurante restaurante = Restaurante.fromMap(restauranteMap);
      return restaurante;
    } else{ 
      return null;
    }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      // ignore: null_argument_to_non_null_type
      return Future.value();
    }
  }

  static insertarRestaurante(Restaurante restaurante) async {
    await coleccion_restaurante.insertAll([restaurante.toMap()]);
  }

static actualizarRestaurante(Restaurante restaurante) async {
  await coleccion_restaurante.updateMany(
    where.eq('_id', restaurante.id),
    modify
      .set('nombre', restaurante.nombre)
      .set('mesas', restaurante.mesas.map((mesa) => mesa.toMap()).toList())
      .set('comentarios', restaurante.comentarios),
  );
}

  static eliminarRestaurante(Restaurante restaurante) async{
    await coleccion_restaurante.deleteOne({"_id": restaurante.id});
  }

static Future<Menu?> getMenu(String idRestaurante) async {
  try {
    final menuMap = await coleccion_menu.findOne( {'idRestaurante': idRestaurante});
    if (menuMap != null) {
      Menu menu = Menu.fromMap(menuMap);
      return menu;
    } else{ 
      return null;
    }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      // ignore: null_argument_to_non_null_type
      return Future.value();
    }
  }

 static Future<bool?> Test() async{
  bool tester = true;
  try{
    final test = await coleccion_test.findOne({'test': 'test'});
  }
  catch(e){
    tester = false; 
    return tester; 
  }
  return tester; 
 }


  static insertarMenu(Menu menu) async {
    await coleccion_menu.insertAll([menu.toMap()]);
  }

static actualizarMenu(Menu menu) async {
  await coleccion_menu.updateMany(
    where.eq('idRestaurante', menu.idRestaurante),
    modify
      .set('itemsMenu', menu.itemsMenu.map((item) => item.toMap()).toList()),
  );
}

  static eliminarMenu(Menu menu) async{
    await coleccion_menu.deleteOne({"idRestaurante": menu.idRestaurante});
  }

  static void agregarPedidoARestaurante(Restaurante restaurante, int idMesa, Pedido nuevoPedido) {
    Mesa? mesaEncontrada = restaurante.mesas.firstWhere((mesa) => mesa.id == idMesa);
    mesaEncontrada.pedidos.add(nuevoPedido);  
  }

}