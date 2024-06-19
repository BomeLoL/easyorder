
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:flutter/material.dart';

class MenuEditController extends ChangeNotifier {

  Menu? menu;

  Future<void> addProduct(String restaurantId, ItemMenu itemMenu) async {
    try {
      await MongoDatabase.agregarProducto(restaurantId, itemMenu);
      menu = await MongoDatabase.getMenu(restaurantId);
      print('${menu!.itemsMenu.length}');
      notifyListeners();
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }
}