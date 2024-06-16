import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/views/Widgets/connectWith.dart';
import 'package:easyorder/views/Widgets/customTextField.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/iconDisplay.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:easyorder/views/singUp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/text_controller.dart';


class Login extends StatelessWidget {
  
  final _auth = Authservice();
  final TextController textController = TextController();


  @override
  Widget build(BuildContext context) {
    final _auth = Authservice();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.065,
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
                    height: size.height * 0.02,
                  ),
                  HorizontalPadding(
                    child: Text(
                      "¡Nos alegra verte de nuevo! Inicia sesión para continuar.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.w500,
                        height: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),

                    child: Column(
                                          children: [

                  SizedBox(height: size.height * 0.03),
                  CustomTextField(hintText: "Ingresa tu correo electrónico", controller: textController.getController('email')),

                  SizedBox(height: size.height * 0.025),
                  CustomTextField(hintText: "Ingresa tu contraseña", controller: textController.getController('password')),
                  SizedBox(height: 15)],)),
                  // HorizontalPadding(
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Text(
                  //       "¿Olvidaste tu contraseña?",
                  //       style: GoogleFonts.poppins(
                  //         fontSize: MediaQuery.of(context).size.height * 0.015,
                  //         fontWeight: FontWeight.w600,
                  //         height: 1.2,
                  //         decoration: TextDecoration.underline,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: size.height * 0.05),
                  HorizontalPadding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: size.height * 0.075,
                            child: ElevatedButton(
                            onPressed: () async {
                              var result = await _auth.loginUserWithEmailAndPassword(
                                textController.getController('email').text,
                                textController.getController('password').text
                              );
                              if (result != null) {
                                Navigator.pop(context);
                              } else {
                                errorLogin(context);
                              }
                            },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF5F04),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:   BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Iniciar Sesión",
                                style: GoogleFonts.poppins(
                                  fontSize: MediaQuery.of(context).size.height * 0.020,
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
                  HorizontalPadding(
                    child: ConnectWith(), // Usa el componente ConnectWith aquí
                  ),
                  SizedBox(height: size.height * 0.04),
                  HorizontalPadding(
                    child: 
                      Row(
                        children: [
                          IconDisplayButton(
                            iconPath: "images/googleIcon.png",
                            text: "Registrarse con Google",
                            onPressed: () async {
                              
                              var x = await _auth.signinwithGoogle();
                              if (x!= null){
                                Navigator.pop(context);

                              }
                            },
                          ),
                        ],
                      ),
                  ),
                  SizedBox(height: size.height * 0.075),
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
                              color: Color(0xFFFF5F04),
                              decorationColor: Color(0xFFFF5F04),
                            ),
                              recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignuP()),
                                );},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalPadding extends StatelessWidget {
  final Widget child;
  const HorizontalPadding({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: child,
    );
  }
}


void errorLogin(BuildContext context) {
  showCustomPopup(
    pop: false,
    context: context,
    title: 'Error',
    content: const Text(
      'Ha ocurrido un error inesperado, por favor revisa tus credenciales',
      textAlign: TextAlign.justify,
    ),
    actions: [
      Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Aquí se corrige la llamada a pop
          },
          child: Text(
            'OK',
            style: GoogleFonts.poppins(
              color: const Color.fromRGBO(255, 96, 4, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}


