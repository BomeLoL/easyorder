import 'item_menu.dart';

class Menu {
  final String idRestaurante;
  List<ItemMenu> itemsMenu;  

  Menu({required this.idRestaurante, required this.itemsMenu });


  Map<String, dynamic> toMap() {  // Exportar
    return {
      'idRestaurante': idRestaurante,
      'itemsMenu': itemsMenu.map((item) => item.toMap()).toList(), // Convertir cada ItemMenu a un mapa
    };
  }

  Menu.fromMap(Map<String, dynamic> map) // Importar
      : idRestaurante = map['idRestaurante'],
        itemsMenu = List<ItemMenu>.from(map['itemsMenu'].map((item) => ItemMenu.fromMap(item))); // Convertir cada mapa en un ItemMenu
}