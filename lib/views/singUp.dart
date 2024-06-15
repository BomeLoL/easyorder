import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/Widgets/connectWith.dart';
import 'package:easyorder/views/Widgets/customTextField.dart'; // Importa CustomTextField
import 'package:easyorder/views/Widgets/iconDisplay.dart';
import 'package:easyorder/views/Widgets/customDropdown.dart'; // Importa CustomDropdown

class SinguP extends StatelessWidget {
  final TextController textController = TextController();
  String userType = "";
  final _auth = Authservice();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.065),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Text(
                    "Créate una cuenta",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      child: Text(
                        "Cree una cuenta para acceder a todas nuestras funcionalidades",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.height * 0.018,
                          fontWeight: FontWeight.w500,
                          height: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "Nombre completo",
                        controller: textController.getController('fullName'),
                      ),
                      SizedBox(height: size.height * 0.025),
                      CustomTextField(
                        hintText: "Ingresa tu correo electrónico",
                        controller: textController.getController('email'),
                      ),
                      SizedBox(height: size.height * 0.025),
                      CustomDropdown(
                        hintText: "¿Eres un Comensal o un Restaurante?",
                        options: ["Comensal", "Restaurante"],
                        onChanged: (value) {
                          userType=value!;
                          print("Selected option: $value");
                        },
                      ),
                      SizedBox(height: size.height * 0.025),
                      CustomTextField(
                        hintText: "Ingresa tu contraseña",
                        controller: textController.getController('password'),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: size.height * 0.08,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try{
                                      await _auth.createUserWithEmailAndPassword(
                                      textController.getController('email').text,
                                      textController.getController('password').text);}
                                  catch(e){
                                    errorSignup;
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
                                  "Crear cuenta",
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
                      SizedBox(height: size.height * 0.06),
                      ConnectWith(),
                      SizedBox(height: size.height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        IconDisplay(iconPath: "images/googleIcon.png",text: "Registrarse con Google"),
                        ],
                      ),
                      SizedBox(height: size.height * 0.075),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "¿Ya tienes cuenta? ",
                            style: GoogleFonts.poppins(
                              fontSize: MediaQuery.of(context).size.height * 0.015,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: "Iniciar sesión",
                                style: GoogleFonts.poppins(
                                  fontSize: MediaQuery.of(context).size.height * 0.015,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                   color: Color(0xFFFF5F04),
                                  decorationColor: Color(0xFFFF5F04),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.075),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

void errorSignup(BuildContext context) {
       
        showCustomPopup(
          pop: false,
          context: context,
          title: 
            'Error',
          content: const Text(
            'A ocurrido un error inesperado, por favor revisa tus credenciales',
            textAlign: TextAlign.justify,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop
                   ;
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