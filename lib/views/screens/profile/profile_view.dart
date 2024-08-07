import 'package:easyorder/controllers/navigation_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/navigationBar/navigationBarClientLogged.dart';
import 'package:easyorder/views/Widgets/navigationBar/navigationBarRestaurant.dart';
import 'package:easyorder/views/screens/Questions/questions_screen.dart';
import 'package:easyorder/views/screens/inicio/inicioView.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/views/Widgets/background_image.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, this.info, this.restaurante, this.idMesa})
      : super(key: key);

  final info;
  final restaurante;
  final idMesa;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer2<UserController, NavController>(
        builder: (context, usercontroller, navcontroller, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Background_image(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + size.height * 0.03),
                Text(
                  'Mi Perfil',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Center(
                  child: ClipOval(
                    child: Container(
                      width: size.height * 0.1,
                      height: size.height * 0.1,
                      child: Image.asset(
                        'images/ProfilePicture.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Divider(
                  color: primaryColor,
                  thickness: 2,
                ),
                SizedBox(height: size.height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información personal',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre:',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            usercontroller.usuario?.nombre ?? 'Sin información',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Correo:',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            usercontroller.usuario?.correo ?? 'Sin información',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de Usuario:',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          usercontroller.usuario?.usertype ?? 'Sin información',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  height: size.height * 0.05,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      usercontroller.usuario = null;
                      navcontroller.selectedIndex = 0;
                      Provider.of<SpinnerController>(context, listen: false)
                          .setLoading(false);
                      Navigator.of(context).popUntil(
                          (route) => route.settings.name == 'menu');
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return InicioView();
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5F04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    label: Text(
                      "Cerrar Sesión",
                      style: GoogleFonts.poppins(
                        fontSize:
                            MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: usercontroller.usuario != null
            ? navBar(context, usercontroller.usuario!.usertype)
            : null,
      );
    });
  }

  Widget navBar(BuildContext context, String rol) {
    if (rol == "Restaurante") {
      return BarNavigationRestaurant();
    } else if (rol == "Comensal") {
      return BarNavigationClientLogged(
          info: widget.info,
          restaurante: widget.restaurante,
          idMesa: widget.idMesa);
    }

    return Container();
  }
}
