import 'dart:async';

import 'package:easyorder/views/escaneoQR.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Get.off(Escanear());
    });
        return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height / 2,
            child: Image.asset(
              'images/fruits.png', // Reemplaza esto con la ruta de tu imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          // Gradiente para opacidad invertida
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0), // Opacidad inicial en la parte superior
                    Colors.white.withOpacity(0.8), // Opacidad intermedia
                    Colors.white.withOpacity(0.9), // Opacidad intermedia
                    Colors.white.withOpacity(1.0), // Opacidad intermedia
                    Colors.white.withOpacity(1.0), // Opacidad máxima en la parte inferior
                    Colors.white.withOpacity(1.0), // Opacidad adicional en la parte inferior
                  ],
                  stops: [0.0, 0.2, 0.4,0.5, 0.7, 1.0], // Puntos de detención de opacidad
                ),
              ),
            ),
          ),
          // Imagen en el medio
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.1, // Ajusta esta posición según sea necesario
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'images/logo.png', // Reemplaza esto con la ruta de tu imagen en medio
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
