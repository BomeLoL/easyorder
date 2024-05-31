import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {

  static var db, coleccion_restaurante,coleccion_menu;
  
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    coleccion_restaurante = db.collection(CRestaurante);
    coleccion_menu = db.collection(CMenu);
  }

  static Future<List<Map<String,dynamic>>?> getRestaurantes(String id) async{
    try{
      final restaurante = await coleccion_restaurante.findOne({'_id':id});
    if (restaurante != null) {
      return restaurante.toMap();
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