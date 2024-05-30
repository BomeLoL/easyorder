import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/detallePedido.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:easyorder/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context){
          return CartController();
        }),
      ],
      child: const MaterialApp(
        home: Menu(info: 'Rip'),
        debugShowCheckedModeBanner: false,
      ),
      );    
  }
}