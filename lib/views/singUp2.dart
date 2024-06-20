import 'package:easyorder/controllers/navigate_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/Widgets/customTextField.dart';
import 'package:easyorder/views/Widgets/customDropdown.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

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
        child: Stack(
          children: [
            SafeArea(
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
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                                          Provider.of<SpinnerController>(context, listen: false).setLoading(true);
                                          var v4 = Uuid().generateV4();
                                          await _auth.createUserDoc(
                                            id: v4,
                                            cuenta: "google",
                                            nombre: textController.getController('fullName').text,
                                            correo: widget.email,
                                            usertype: userType,
                                          );
                                        cerrarTeclado(context);
                                        UserController userController = Provider.of<UserController>(context, listen: false);
                                        var getUsuario = await _auth.getUserByEmailAndAccount(widget.email,'google');
                                        userController.usuario = getUsuario;
                                          if (userType == "Restaurante") {
                                            await MongoDatabase.insertarRestaurante(
                                              v4,
                                              textController.getController('fullName').text,
                                            );
                                          var restaurante = await MongoDatabase.getRestaurante(v4);
                                          var menu = await MongoDatabase.getMenu(v4);
                                          if (restaurante!= null && menu!=null){
                                          NavigateController().navigateToMenu(context,restaurante, menu, "1","Restaurante");} 
                                          } else {
                                            Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => Escanear()),
                                          );                                      }
                                        } }catch (e) {
                                          errorSignup(context);
                                        }
                                        Provider.of<SpinnerController>(context, listen: false).setLoading(true);
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
            Consumer<SpinnerController>(builder: (context, spinnerController, child){
                if(spinnerController.isLoading){
                  return AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 228, 221),  // Color de fondo del contenedor
                            borderRadius: BorderRadius.circular(10),  // Radio de los bordes
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        ),
                    ),
                  );
                }else{
                  return Container();
                }
              })
          ],
        ),
      ),
    );
  }
}

void cerrarTeclado(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
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
