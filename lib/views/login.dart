import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.065, // Aumenta la altura para más espacio superior
              ),
              Text(
                "Inicio de Sesión",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.height * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.02, // Aumenta la altura para más espacio superior
              ),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Añade margen horizontal
              child: Text(
              "¡Nos alegra verte de nuevo! Inicia sesión para continuar.",
                   textAlign: TextAlign.center,
                   style: GoogleFonts.poppins(
                     fontSize: MediaQuery.of(context).size.height * 0.018,
                     fontWeight: FontWeight.w500,
                     height:2,
                   ),
                 ),
               ),
              SizedBox(height: size.height * 0.03),
              inputLogin(size, "Ingresa tu correo electrónico", 0),
              SizedBox(height: size.height * 0.025),
              inputLogin(size, "Ingresa tu contraseña", 0.5),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos horizontalmente
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.08,
                        child: ElevatedButton(
                          onPressed: () async {
                            final tester = await MongoDatabase.Test();
                            if (tester == false) {
                              // ignore: use_build_context_synchronously
                              dbErrorDialog(context);
                            } else {
                              // Procede con la lógica para iniciar sesión
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF5F04),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Iniciar Sesión",
                            style: GoogleFonts.poppins(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.020,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.06),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 4,
                          width: size.width * 0.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.orange.withOpacity(0.0), // Opacidad más baja
                                Colors.orange.withOpacity(
                                    0.2), // Opacidad más baja
                                Colors.orange.withOpacity(
                                    0.5), // Opacidad media
                                Colors.orange.withOpacity(
                                    1), // Opacidad más alta
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "o conéctate con",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 4,
                          width: size.width * 0.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.orange.withOpacity(
                                    1), // Opacidad más alta
                                Colors.orange.withOpacity(
                                    0.5), // Opacidad media
                                Colors.orange.withOpacity(
                                    0.2), // Opacidad más baja
                                Colors.orange.withOpacity(
                                    0.0), // Opacidad más baja
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconDisplay("images/googleIcon.png"),
                    iconDisplay("images/facebookIcon.png"),
                    iconDisplay("images/appleIcon.png"),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.07),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "¿Es tu primera vez? ",
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "Registrarse",
                        style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                      fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded iconDisplay(String icono) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFECE9EC),
          shape: BoxShape.circle, // Hace que el contenedor sea circular
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        padding: EdgeInsets.all(12), // Espacio interno del contenedor
        child: Image.asset(
          icono,
          width: 28, // Ancho del icono
          height: 40, // Alto del icono
        ),
      ),
    );
  }

  Padding inputLogin(Size size, String hint, double opacidad) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
      // Añade padding horizontal al contenedor
      child: Material(
        // Envuelve con Material para aplicar sombra
        elevation: 3, // Elevación para la sombra
        borderRadius: BorderRadius.circular(15), // Borde redondeado del Material
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF3F3F3), // Color de fondo del contenedor
            borderRadius:
                BorderRadius.circular(15), // Borde redondeado del contenedor
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            // Añade padding horizontal al TextField
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15, // Ajusta el padding horizontal del contenido del TextField
                  vertical: 25, // Ajusta el padding vertical del contenido del TextField
                ),
                fillColor: Color(0xFFF3F3F3),
                // Cambia el color de fondo aquí si es necesario
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: Opacity(
                  opacity: opacidad,
                  // Ajusta la opacidad del ícono (0.0 - 1.0)
                  child: Icon(Icons.visibility_off_outlined, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
