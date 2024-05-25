import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class pantallaCarga extends StatelessWidget {
  const pantallaCarga({super.key});

  @override
  Widget build(BuildContext context) {
    //Se usa PopScope para evitar que el usuario pueda salir de la pantalla de carga
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(255, 96, 4, 1),
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitPouringHourGlass(
                    size: 250,
                    color: Colors.white,
                  ),
                  Text(
                    'Su pedido se esta realizando',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
