import 'item_menu.dart';

class Menu {
  final String idRestaurante;
  List<ItemMenu> itemsMenu = [];  

  Menu({required this.idRestaurante, List<ItemMenu>? itemsMenu });


  Map<String, dynamic> toMap(){  //Exportar
    return{
     'idRestaurante': idRestaurante ,
     'itemsMenu': itemsMenu,

   };
 }

  Menu.fromMap(Map<String, dynamic> map) //Importar
  : idRestaurante = map['idRestaurante'],
  itemsMenu = map['itemsMenu'];
}