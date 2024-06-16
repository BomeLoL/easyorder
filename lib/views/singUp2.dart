import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/Widgets/customTextField.dart';
import 'package:easyorder/views/Widgets/customDropdown.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SignuP2 extends StatefulWidget {
  final String email;

  SignuP2({required this.email});

  @override
  _SignuP2State createState() => _SignuP2State();
}

class _SignuP2State extends State<SignuP2> {
  final TextController textController = TextController();
  String userType = "";
  bool _submitted = false;
  final _auth = Authservice();
  bool showErrorUserType = true;

String? _validateFullName(String? value) {
  if (_submitted && (value == null || value.isEmpty)) {
    return 'Por favor ingresa tu nombre completo';
  }
  if (_submitted && value!.trim().isEmpty) {
    return 'El nombre completo no puede consistir únicamente de espacios en blanco';
  }
  if (_submitted && (value!.startsWith(' ') || value.endsWith(' '))) {
    return 'El nombre completo no puede empezar ni terminar con espacios en blanco';
  }
  return null;
}

  String? _validateUserType(String? value) {
    if (_submitted && (value == null || value.isEmpty || value == "")) {
      return 'Por favor indique el tipo de usuario';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    showCustomPopup(
      pop: false,
      context: context,
      title: 'Error',
      content: Text(
        message,
        textAlign: TextAlign.justify,
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: const Color.fromRGBO(255, 96, 4, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

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
                    "Finalizando tu Registro con Google",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Text(
                    "Ya estamos casi listos. Continúa para finalizar el proceso.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                      fontWeight: FontWeight.w500,
                      height: 2,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "Nombre completo",
                        controller: textController.getController('fullName'),
                        errorText: _validateFullName(textController.getController('fullName').text),
                      ),
                      SizedBox(height: size.height * 0.025),
                      CustomDropdown(
                        hintText: "¿Eres un Comensal o un Restaurante?",
                        options: ["Comensal", "Restaurante"],
                        showError: showErrorUserType,  // Estado para mostrar el error del tipo de usuario
                        errorText: _validateUserType(userType),  // Mensaje de error para el tipo de usuario
                        onChanged: (value) {
                          setState(() {
                            userType = value!;  // Actualizar el tipo de usuario seleccionado
                            showErrorUserType = false;  // Ocultar el mensaje de error del tipo de usuario
                          });
                          print("Selected option: $value");
                        },
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
                                  setState(() {
                                    _submitted = true;
                                  });

                                  String? fullNameError = _validateFullName(textController.getController('fullName').text);
                                  String? userTypeError = _validateUserType(userType);

                                  if (fullNameError != null || userTypeError != null) {
                                    // Mostrar error
                                  } else {
                                    // Lógica para crear cuenta
                                    try {
                                      var v4 = Uuid().generateV4();
                                      await _auth.createUserDoc(
                                        cuenta: "google",
                                        nombre: textController.getController('fullName').text,
                                        correo: widget.email,
                                        usertype: userType,
                                      );
                                      if (userType == "Restaurante") {
                                        await MongoDatabase.insertarRestaurante(
                                          v4,
                                          textController.getController('fullName').text,
                                        );
                                      } else {
                                        // uwu
                                      }
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    } catch (e) {
                                      errorSignup(context);
                                    }
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
    title: 'Error',
    content: const Text(
      'Ha ocurrido un error inesperado, por favor revisa tus credenciales',
      textAlign: TextAlign.justify,
    ),
    actions: [
      Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();  // Aquí es donde se debe cerrar el diálogo correctamente
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