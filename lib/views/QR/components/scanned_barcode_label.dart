import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    Key? key,
    required this.barcodes,
    required this.tipo,
  }) : super(key: key);

  final Stream<BarcodeCapture> barcodes;
  final int tipo;

  @override
  Widget build(BuildContext context) {
    String errorMessage = '';
    if (tipo == 1) {
      errorMessage = "Qr inválido";
    } else if (tipo == 2) {
      errorMessage = "Error en la conexión. Regrese e intente nuevamente.";
    }

    return Stack(
      children: [
        StreamBuilder(
          stream: barcodes,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment(0.0, -0.6),
                child: Container(
                  height: 70.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Text(
                      'Escanea el Qr para acceder al Menú',
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (tipo != 0) // Añadir condicional para mostrar el error solo si tipo != 0
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment(0.0, 0.6),
              child: Container(
                height: 80.0,
                width: 260.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Espacio entre el texto y los bordes del contenedor
                    child: Text(
                      errorMessage,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center, // Centrar el texto
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}