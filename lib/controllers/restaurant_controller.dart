import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/foundation.dart';

class RestaurantController with ChangeNotifier {
  Restaurante? restaurante = null;

  Restaurante? get _restaurante => restaurante;

  void deleteTable() {}

  void addTable() {}
}
