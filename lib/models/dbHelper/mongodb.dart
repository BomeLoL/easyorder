import 'dart:async';

import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, coleccion_restaurante, coleccion_menu;
  // ignore: unused_field
  static Timer? _connectionCheckTimer;

  static Future<void> connect({int retries = 5, Duration delay = const Duration(seconds: 2)}) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        db = await Db.create(MONGO_URL);
        await db.open();
        coleccion_restaurante = db.collection(CRestaurante);
        coleccion_menu = db.collection(CMenu);
        return;
      } catch (e) {
        if (attempt < retries - 1) {
          await Future.delayed(delay);
        } else {
          rethrow;
        }
      }
    }
  }

  static Future<bool> checkConnection() async {
    try {
      final restaurante = await coleccion_restaurante.getRestaurantes("1");
      return restaurante != null;
    } catch (e) {
      return false;
    }
  }

  static Future<void> initializeDatabase() async {
    try {
      await MongoDatabase.connect();
    } catch (e) {
      // Manejar el error de conexión si es necesario
    }
  }

  static void startConnectionCheckTimer() {
    _connectionCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      bool isConnected = await MongoDatabase.checkConnection();
      if (!isConnected) {
        await initializeDatabase();
      }
    });
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


}