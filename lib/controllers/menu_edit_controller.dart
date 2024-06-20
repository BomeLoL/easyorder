import 'package:easyorder/models/dbHelper/firebase_service.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:flutter/material.dart';

class MenuEditController extends ChangeNotifier {

  Menu? menu;

  String _selectedCategoria = "Todo";

  String get selectedCategoria => _selectedCategoria;

  set selectedCategoria(String value) {
    _selectedCategoria = value;
    notifyListeners();
  }

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

  Future<void> deleteProduct(String restaurantId, ItemMenu producto) async {
    try {
      await MongoDatabase.eliminarProducto(restaurantId, producto.id);
      await FirebaseService.deleteImageFromStorage(producto.imgUrl);
      menu = await MongoDatabase.getMenu(restaurantId);
      notifyListeners(); // Notificar a los listeners (widgets) que hay cambios
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Future<void> editProduct(String restaurantId, ItemMenu itemMenu) async {
    try {
      await MongoDatabase.editarProducto(restaurantId, itemMenu);
      menu = await MongoDatabase.getMenu(restaurantId);
      notifyListeners();
    } catch (e) {
      throw Exception('Error editing product: $e');
    }
  }

}