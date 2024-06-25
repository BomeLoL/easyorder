import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/navigate_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/screens/inicio/inicioView.dart';
import 'package:easyorder/views/screens/login/login.dart';
import 'package:easyorder/views/screens/signup2/singUp2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/customTextField.dart';
import 'package:easyorder/views/Widgets/customDropdown.dart';
import 'package:easyorder/views/Widgets/iconDisplay.dart';
import 'package:easyorder/views/Widgets/connectWith.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

class SignuP extends StatefulWidget {
  @override
  _SignuPState createState() => _SignuPState();
}

class _SignuPState extends State<SignuP> {
  final TextController textController = TextController();
  String userType = "";
  final _auth = Authservice();
  var email;
  bool _submitted = false;
  bool showErrorUserType  = true;



String? _validateEmail(String? value) {
  if (_submitted && (value == null || value.isEmpty)) {
    return 'Por favor ingresa tu correo electrónico';
  }
  if (_submitted && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value ?? '')) {
    return 'Por favor ingresa un correo electrónico válido';
  }

  return null;
}

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
String? _validatePassword(String? value) {
  if (_submitted && (value == null || value.isEmpty)) {
    return 'Por favor ingresa tu contraseña';
  }
  if (_submitted && value!.trim().length < 8) {
    return 'La contraseña debe tener al menos 8 caracteres';
  }
  if (_submitted && value!.contains(' ')) {
    return 'La contraseña no puede contener espacios en blanco';
  }
  return null;
}

  String? _validateUserType(String? value) {
    // Método para validar el tipo de usuario
    if (_submitted && (value == null || value.isEmpty || value == "")) {
      return 'Por favor indique el tipo de usuario';
    }
    return null;
  }

  // Función para mostrar el popup de error
  void showErrorPopup(BuildContext context, String message) {
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
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return InicioView();
                
                  },
                ),
              );
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
                            errorText: _validateFullName(textController.getController('fullName').text),
                          ),
                          SizedBox(height: size.height * 0.025),
                          CustomTextField(
                            hintText: "Ingresa tu correo electrónico",
                            controller: textController.getController('email'),
                            errorText: _validateEmail(textController.getController('email').text),
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
                          SizedBox(height: size.height * 0.025),
                          CustomTextField(
                            hintText: "Ingresa tu contraseña",
                            controller: textController.getController('password'),
                            errorText: _validatePassword(textController.getController('password').text),
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
                                  String? emailError = _validateEmail(textController.getController('email').text);
                                  String? fullNameError = _validateFullName(textController.getController('fullName').text);
                                  String? passwordError = _validatePassword(textController.getController('password').text);
                                  String? userTypeError = _validateUserType(userType);
            
            
                                  if (emailError != null || fullNameError != null || passwordError != null || userTypeError !=null)  {
                                    // Mostrar errores si hay campos inválidos
                                  } else {
                                    try {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                                      Provider.of<SpinnerController>(context, listen: false).setLoading(true);
                                      var v4 = Uuid().generateV4();
                                      var x = await _auth.createUserWithEmailAndPassword(
                                        textController.getController('email').text,
                                        textController.getController('password').text,
                                      );
                                      if (x != null) {
                                        _auth.createUserDoc(
                                          id: v4,
                                          cuenta: "correo",
                                          nombre: textController.getController('fullName').text,
                                          correo: textController.getController('email').text,
                                          usertype: userType,
                                        );
                                       UserController userController = Provider.of<UserController>(context, listen: false);
                                        var getUsuario = await _auth.getUserByEmailAndAccount(textController.getController('email').text,'correo');
                                        userController.usuario = getUsuario;
                                        cerrarTeclado(context);
                                        if (userType == "Restaurante") {
                                          await MongoDatabase.insertarRestaurante(v4, textController.getController('fullName').text);
                                          var restaurante = await MongoDatabase.getRestaurante(v4);
                                          var menu = await MongoDatabase.getMenu(v4);
                                          if (restaurante!= null && menu!=null){
                                          NavigateController().navigateToMenu(context,restaurante, menu, "1","Restaurante");} 
                                        }else{
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return InicioView();
                          
                                          }
                                        ),
                                      );
                                        }
                                      }
                                      
                                      else {
                                        showErrorPopup(context, 'Hubo un error inesperado, por favor revisa tus datos');
            
                                      }
                                    }} catch (e) {
                                      Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                                      showErrorPopup(context, 'Hubo un error inesperado, por favor revisa tus datos');
                                    }
                                    Provider.of<SpinnerController>(context, listen: false).setLoading(false);
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
                            children: [
                              IconDisplayButton(
                                iconPath: "images/googleIcon.png",
                                text: "Registrarse con Google",
                                onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                                  Provider.of<SpinnerController>(context, listen: false).setLoading(true);
                                  email = await _auth.signinwithGoogle();
                                  if (email != null) {
                                    await _auth.getUserByEmailAndAccount(email, 'google');
                                    var getUsuario = await _auth.getUserByEmailAndAccount(email, 'google');
                                    if (getUsuario == null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SignuP2(email: email,)),
                                      );
                                    }  else {
                                        UserController userController = Provider.of<UserController>(context, listen: false);
                                        userController.usuario = getUsuario;
                                    if (userController.usuario?.usertype == "Restaurante"){
                                          var restaurante = await MongoDatabase.getRestaurante(userController.usuario!.id);
                                          var menu = await MongoDatabase.getMenu(userController.usuario!.id);
                                          if (restaurante!= null && menu!=null){
                                          NavigateController().navigateToMenu(context,restaurante, menu, "1","Restaurante");}
                                    }else{
            
                                    Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return InicioView();
                          
                                          }
                                        ),
                                      );
                                    }
                                    }     
                                }
                                Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                                }},
                              ),
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
                                  recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login()),
                                    );},
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