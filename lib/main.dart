import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
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
      ],
      child: const MaterialApp(
        home: Escanear(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
