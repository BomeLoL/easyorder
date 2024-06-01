import 'package:flutter/material.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';



Future<bool> RevisarBd(barcode) async {
  String infoQr = barcode.first.displayValue;
  try {
    var ids = infoQr.split(",");
    String idRestaurante=ids[0];
    var restaurantes;
    String idMesa=ids[1];
    restaurantes = await MongoDatabase.getRestaurantes("1");
    if (restaurantes==null) {
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print(restaurantes);
    } else if (restaurantes!=null) {
      print("bASTAAAAAAAAAAAAAAAAAAA");
      print(restaurantes);
      print("MATENMEEEEEE");
      print(restaurantes[0]["nombre"]);
    }
    
    
  } catch (e) {
    
  }
  
  return false;

}