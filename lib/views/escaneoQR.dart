import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/login.dart';
import 'package:easyorder/views/singUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/vistaQr.dart';

class Escanear extends StatefulWidget {
  const Escanear({Key? key}) : super(key: key);

  @override
  State<Escanear> createState() => _EscanearState();
}

class _EscanearState extends State<Escanear> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo que cubre solo el área encima del contenedor blanco
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Image.asset(
              'images/fondoInicio.png',
              fit: BoxFit.fitWidth,
            ),
          ),
                    Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'images/logoSinFondoNiLetras.png',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.55),
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
                  Text("Bienvenido", style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("¡Descubre todo lo que EasyOrder te ofrece!", style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width * 0.028, fontWeight: FontWeight.w500)),
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35), // Agrega un espacio a cada lado del botón
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () async {
                                final tester = await MongoDatabase.Test();
                                if (tester == false) {
                                  // ignore: use_build_context_synchronously
                                  dbErrorDialog(context);
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BarcodeScannerWithOverlay()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF5F04),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Escanea ahora", style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold)),
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
                            child: ElevatedButton(
                              onPressed: () async {
                                // final tester = await MongoDatabase.Test();
                                // if (tester == false) {
                                //   // ignore: use_build_context_synchronously
                                //   dbErrorDialog(context);
                                // } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFFFF5F04),
                                side: BorderSide(width: 2, color: Color(0xFFFF5F04)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Iniciar sesión", style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.w500)),
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
                            child: ElevatedButton(
                              onPressed: () async {
                                // final tester = await MongoDatabase.Test();
                                // if (tester == false) {
                                //   // ignore: use_build_context_synchronously
                                //   dbErrorDialog(context);
                                // } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignuP()));
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFFFF5F04),
                                side: BorderSide(width: 2, color: Color(0xFFFF5F04)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Registrarse", style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logo encima de todo

        ],
      ),
    );
  }
}


    // return Scaffold(
    //   extendBodyBehindAppBar: true,
    //   appBar: AppBar(
    //   //  automaticallyImplyLeading: false,
    //     centerTitle: true,
    //     title: Text("EasyOrder",
    //       style: GoogleFonts.poppins(),
    //     ),
    //     elevation: 0,
    //   ),
    //   body: Center(
    //     child:Container(
    //       child: ElevatedButton(
    //         onPressed: ()async{

    //           final tester = await MongoDatabase.Test();
    //           if (tester == false){
    //             // ignore: use_build_context_synchronously
    //             dbErrorDialog(context);
    //           } else{ 
    //           Navigator.push(context, MaterialPageRoute(builder: (context){return BarcodeScannerWithOverlay();}));
    //           }
    //           },
    //         style: ElevatedButton.styleFrom(
    //         backgroundColor: Color(0xFFFF5F04),
    //         foregroundColor: Colors.white,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10)
    //           ),
    //         minimumSize: Size(200, 60),
    //         ),
    //         child: Text("Escanear",style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),),
    //         ),
    //     ),
    //     ),
    // );


