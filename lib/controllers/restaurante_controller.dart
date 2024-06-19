import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/vistaMesas.dart';
import 'package:flutter/material.dart';

class RestauranteController extends ChangeNotifier {
  Restaurante? _restaurante;

  Restaurante? get restaurante => _restaurante;

  set restaurante(Restaurante? restaurante) {
    _restaurante = restaurante;
    notifyListeners();
  }

  Future<void> getMesas(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Vistamesas(mesa: restaurante!.mesas);
        },
      ),
    );
  }

  void addMesa(List mesas, Restaurante restaurante) async {
    //pasas los parametros necesarios
    MongoDatabase.actualizarRestaurante(restaurante);
    _restaurante = restaurante;
    notifyListeners();
    //llamas a la bd con el actualizar restaurabte

    notifyListeners();
  }

  void deleteMesa(List mesas, Restaurante restaurante) async {
    MongoDatabase.actualizarRestaurante(restaurante);
    _restaurante = restaurante;
    notifyListeners();
  }
}
