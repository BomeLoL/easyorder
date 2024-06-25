import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/screens/inicio/components/orange_background_button.dart.dart';
import 'package:easyorder/views/screens/inicio/components/orange_text_button.dart.dart';
import 'package:easyorder/views/screens/inicio/layouts/background_image.dart';
import 'package:easyorder/views/screens/login/login.dart';
import 'package:easyorder/views/screens/signup/signUp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/screens/QR/vistaQr.dart';
import 'package:provider/provider.dart';

class InicioView extends StatefulWidget {
  const InicioView({Key? key}) : super(key: key);

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<UserController,NavController>(
        builder: (context, usercontroller, navcontroller,child) {
          return Stack(
            children: [
              BackgroundImage(imagePath: 'images/fondoInicio.png'),
              BackgroundImage(imagePath: 'images/logoSinFondoNiLetras.png', position: 0.4),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.55),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35), // Agrega un espacio a cada lado del texto
                        child: Text(
                          "Bienvenido",
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35), // Agrega un espacio a cada lado del texto
                        child: Text(
                          "¡Descubre todo lo que EasyOrder te ofrece!",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (usercontroller.usuario == null) ...[
                      SizedBox(height: 18)] else if (usercontroller.usuario != null)... [SizedBox(height: 26)],
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35), // Agrega un espacio a cada lado del botón
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: OrangeBackgroundButton(
                                    text: "Escanea ahora",
                                    onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BarcodeScannerWithOverlay(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20), // Agrega un espacio entre los botones
                      if (usercontroller.usuario == null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: OrangeTextButton(
                                    text: "Iniciar sesión",
                                    onPressed: () {
                                      Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20), // Agrega un espacio entre los botones
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: OrangeTextButton(
                                    text: "Registrarse",
                                    onPressed: () {
                                      Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignuP()));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (usercontroller.usuario != null) ... [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: OrangeTextButton(
                                    text: "Cerrar sesión",
                                    onPressed: () {
                                      usercontroller.usuario = null;
                                      navcontroller.selectedIndex=0;
                                      Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return InicioView();
                                  
                                      },
                                    ),
                                  );
                                  },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] 
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
