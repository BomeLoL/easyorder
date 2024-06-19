import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';

class ProductsController {
  
  Future<void> addProduct(String restaurantId, ItemMenu itemMenu) async {
    try {
      await MongoDatabase.agregarProducto(restaurantId, itemMenu);
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }
}