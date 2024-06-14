import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class pantallaCarga extends StatelessWidget {
  const pantallaCarga({super.key});

  @override
  Widget build(BuildContext context) {
    //Se usa PopScope para evitar que el usuario pueda salir de la pantalla de carga
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(255, 96, 4, 1),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SpinKitPouringHourGlassRefined(
                    size: 250,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 45),
                  Text(
                    'Su pedido se esta realizando',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
