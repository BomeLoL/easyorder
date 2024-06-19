import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/firebase_options.dart';
import 'package:easyorder/models/dbHelper/Enviroment.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:easyorder/views/qrMesa.dart';
import 'package:easyorder/views/registro_mesa.dart';
import 'package:easyorder/views/splashView.dart';
import 'package:easyorder/views/vistaMesas.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:easyorder/views/walletView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/views/menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase y carga de variables de entorno
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: Enviroment.fileName);

  // Conexión a MongoDB
  try {
    await MongoDatabase.connect();
  } catch (e) {
    // Manejar errores de conexión a MongoDB aquí
    print('Error de conexión a MongoDB: $e');
  }

  // Configuración de orientaciones de pantalla y ejecución de la aplicación
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PedidoController()),
        ChangeNotifierProvider(create: (context) => CartController()),
        ChangeNotifierProvider(create: (context) => TextController()),
        ChangeNotifierProvider(create: (context) => CheckController()),
        ChangeNotifierProvider(create: (context) => UserController()),
        ChangeNotifierProvider(create: (context) {
          return NavController();
        }),
        ChangeNotifierProvider(create: (context) {
          return MenuEditController();
        }),
        ChangeNotifierProvider(
          create: (context) => TextController(),
          child: MyApp(),
        ),
      ],
      child: GetMaterialApp(
        defaultTransition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 600),
        home: const SplashView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
