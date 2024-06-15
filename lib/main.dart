import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/dbHelper/Enviroment.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:easyorder/views/qrMesa.dart';
import 'package:easyorder/views/registro_mesa.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:easyorder/views/walletView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easyorder/views/menu.dart';

Future<void> main() async {
  await dotenv.load(fileName: Enviroment.fileName);
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MongoDatabase.connect();
    // ignore: empty_catches
  } catch (e) {}
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return CartController();
        }),
        ChangeNotifierProvider(create: (context) {
          return NavController();
        })
      ],
      child: const MaterialApp(
        home: RegistroMesa(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
