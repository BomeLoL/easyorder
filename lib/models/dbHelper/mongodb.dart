import 'dart:async';
import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/mesa.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

  class MongoDatabase {
    static var db, coleccion_restaurante, coleccion_menu, coleccion_test,coleccion_categories;
    // ignore: unused_field
    static Timer? _connectionCheckTimer;
    static String? MONGO_URL = dotenv.env["MONGO_URL"];
    static connect() async{
      try{
      db = await Db.create(MONGO_URL!); 
        await db.open();
      coleccion_menu = db.collection(CMenu);
      coleccion_restaurante = db.collection(CRestaurante);
      coleccion_test = db.collection(Ctest);
      coleccion_categories = db.collection(Ccategories);

      }
      catch(e){
        print(e);
      }
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

  static insertarRestaurante(String id, String nombre) async {
    Restaurante restaurante = Restaurante(
      id: id,
      nombre: nombre,
      mesas: [Mesa(id: 1, pedidos: [])],
      comentarios: [],
    );

    Menu menu = Menu(idRestaurante: id, itemsMenu: []);
    
    // Insertar restaurante
    await coleccion_restaurante.insertOne(restaurante.toMap());

    // Insertar menú
    await coleccion_menu.insertOne(menu.toMap());

    // Insertar categorías vacías
    await coleccion_categories.insertOne({
      'idRestaurante': id,
      'categorias': [], // Categorías inicialmente vacías
    });
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

  static Future<bool?> Test() async{
    bool tester = true;
    try{
      final test = await coleccion_test.findOne({'test': 'test'});
    }
    catch(e){
      tester = false; 
      return tester; 
    }
    return tester; 
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

  static void agregarPedidoARestaurante(Restaurante restaurante, int idMesa, Pedido nuevoPedido) {
    Mesa? mesaEncontrada = restaurante.mesas.firstWhere((mesa) => mesa.id == idMesa);
    mesaEncontrada.pedidos.add(nuevoPedido);  
  }

  ///Agrega un producto nuevo al menú del restaurante
  static Future<void> agregarProducto(String idRestaurante, ItemMenu itemMenu) async {
  try {
    final menu = await getMenu(idRestaurante);
    if (menu != null) {
      // Verificar si el producto ya existe en el menú
      bool productoExistente = menu.itemsMenu.any((item) => item.id == itemMenu.id);
      if (productoExistente) {
        throw Exception('El producto ya existe en el menú');
      }

      // Si el producto no existe, agregarlo al menú
      menu.itemsMenu.add(itemMenu);
      await actualizarMenu(menu);
    } 
  } catch (e) {
    throw Exception('Error al agregar el producto: $e');
  }
}
///Elimina un producto del menu del restaurante
static Future<void> eliminarProducto(String idRestaurante, int idProducto) async {
  try {
    // Obtener el menú del restaurante
    Menu? menu = await getMenu(idRestaurante);
    if (menu == null) {
      throw Exception('Menú no encontrado para el restaurante con ID: $idRestaurante');
    }

    // Buscar el producto por su ID
    bool productoEncontrado = false;
    menu.itemsMenu.removeWhere((item) {
      if (item.id == idProducto) {
        productoEncontrado = true;
        return true;
      }
      return false;
    });

    // Si no se encontró el producto, lanzar una excepción
    if (!productoEncontrado) {
      throw Exception('El producto con ID: $idProducto no existe en el menú del restaurante');
    }

    // Actualizar el menú en la base de datos
    await actualizarMenu(menu);
    print('Producto eliminado exitosamente del menú');
  } catch (e) {
    print('Error al eliminar el producto: $e');
    throw Exception('Error al eliminar el producto: $e');
  }
}

///Este método es para editar un producto del menú del restaurante
static Future<void> editarProducto(String idRestaurante, ItemMenu itemMenu) async {
    try {
      final menu = await getMenu(idRestaurante);
      if (menu != null) {
        // Encontrar el índice del producto a editar
        int index = menu.itemsMenu.indexWhere((item) => item.id == itemMenu.id);
        if (index != -1) {
          // Reemplazar el producto existente con el nuevo
          menu.itemsMenu[index] = itemMenu;
          await actualizarMenu(menu);
        } else {
          throw Exception('Producto no encontrado en el menú');
        }
      } else {
        throw Exception('Menú no encontrado');
      }
    } catch (e) {
      throw Exception('Error al editar el producto: $e');
    }
  }

static Future<Pedido?> consolidarPedidos(String restauranteId, int numeroMesa) async {
  if (db == null || !db.isConnected) {
    await connect();
  }

  try {
    Restaurante? restaurante = await getRestaurante(restauranteId);

    if (restaurante == null) {
      print('Restaurante no encontrado');
      return null;
    }

    Mesa? mesa = restaurante.mesas.firstWhere((mesa) => mesa.id == numeroMesa);

    if (mesa == null) {
      print('Mesa no encontrada');
      return null;
    }

    Pedido pedidoConsolidado = Pedido(productos: []);

    if (mesa.pedidos.isEmpty) {
      return pedidoConsolidado;
    }

    // Crear un nuevo pedido consolidado

    // Map para almacenar productos y sumarlos
    Map<String, itemPedido> mapaProductos = {};

    // Iterar sobre los pedidos de la mesa
    for (Pedido pedido in mesa.pedidos) {
      for (itemPedido item in pedido.productos) {
        String clave = '${item.producto.id}-${item.comentario ?? ''}';

        if (mapaProductos.containsKey(clave)) {
          mapaProductos[clave]!.cantidad += item.cantidad;
        } else {
          mapaProductos[clave] = itemPedido(
            producto: item.producto,
            cantidad: item.cantidad,
            comentario: item.comentario,
            extras: item.extras,
          );
        }
      }
    }

    // Agregar productos al pedido consolidado
    pedidoConsolidado.agregarProductos(mapaProductos.values.toList());

    return pedidoConsolidado;
  } catch (e) {
    print(e);
    return null;
  }
}

  static Future<void> vaciarPedidosDeMesa(String idRestaurante, int idMesa) async {
    try {
      // Obtener el restaurante
      Restaurante? restaurante = await getRestaurante(idRestaurante);
      if (restaurante == null) {
        throw Exception('Restaurante no encontrado');
      }

      // Encontrar la mesa específica dentro del restaurante
      Mesa? mesa = restaurante.mesas.firstWhere((mesa) => mesa.id == idMesa);
      if (mesa == null) {
        throw Exception('Mesa no encontrada en el restaurante');
      }

      // Vaciar la lista de pedidos de la mesa
      mesa.pedidos.clear();

      // Actualizar el restaurante en la base de datos
      await actualizarRestaurante(restaurante);
    } catch (e) {
      print('Error al vaciar pedidos de mesa: $e');
      rethrow; // Reenviar la excepción para manejo externo si es necesario
    }
  }

  // ... otros métodos de la clase


static Future<List<String>> getCategorias(String idRestaurante) async {
  try {
    final categorias = await coleccion_categories.findOne({'idRestaurante': idRestaurante});

    if (categorias != null && categorias['categorias'] != null) {
      // Si se encontraron categorías y el campo 'categorias' no es nulo
      List<String> categoriasList = List<String>.from(categorias['categorias']);
      return categoriasList;
    } else {
      // Si no se encontraron categorías o el campo 'categorias' está vacío
      return [];
    }
  } catch (e) {
    // Manejar cualquier error durante la consulta
    print('Error al obtener categorías: $e');
    return []; // Devolver una lista vacía en caso de error
  }
}

static actualizaCategorias (List categorias, String idRestaurante) async {
   await coleccion_categories.updateOne(
        where.eq('idRestaurante', idRestaurante),
        modify.set('categorias', categorias),
      );
}



}
