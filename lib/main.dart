import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/firebase_options.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/dbHelper/Enviroment.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:easyorder/views/splashView.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: Enviroment.fileName);
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
        ChangeNotifierProvider(
          create: (context) {
            return CartController();
          },
        ),
      ],
      child: GetMaterialApp(
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 600 ),
      home: const SplashView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}