import 'package:easyorder/controllers/navigate_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/usuario.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/connectWith.dart';
import 'package:easyorder/views/Widgets/customTextField.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/iconDisplay.dart';
import 'package:easyorder/views/screens/inicio/inicioView.dart';
import 'package:easyorder/views/screens/signup/signUp.dart';
import 'package:easyorder/views/screens/signup2/singUp2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class Login extends StatefulWidget {
  
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextController textController = TextController();

  bool isLoading = false;

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
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                              var result = await _auth.loginUserWithEmailAndPassword(
                                textController.getController('email').text,
                                textController.getController('password').text
                              );
                              if (result != null) {
                                Provider.of<SpinnerController>(context, listen: false).setLoading(true);
                                 UserController userController = Provider.of<UserController>(context, listen: false);
                                cerrarTeclado(context);                                
                                Usuario? getUsuario = await _auth.getUserByEmailAndAccount(textController.getController('email').text,'correo');
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
                                Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                              } else {
                                errorLogin(context);
                                Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                              }
                            }},

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
                            text: "Iniciar sesión con Google",
                            onPressed: () async {  
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                              Provider.of<SpinnerController>(context, listen: false).setLoading(true);                            
                              var email = await _auth.signinwithGoogle();                              
                              if (email != null) {
                                _auth.getUserByEmailAndAccount(email, 'google');
                                var getUsuario = await _auth.getUserByEmailAndAccount(email, 'google');
                                if (getUsuario == null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignuP2(email: email,)),
                                  );
                                } else {
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
                                  );}
                                }                                    


                              }
                              Provider.of<SpinnerController>(context, listen: false).setLoading(false);
                            }},
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

void cerrarTeclado(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
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


