import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
    required this.tipo,
  });

  final Stream<BarcodeCapture> barcodes;
  final int tipo;

  @override
  Widget build(BuildContext context) {

    if (tipo==0) {
      return StreamBuilder(
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
    );
    } else {
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment(0.0, 0.6),
            child: Container(
                  height: 50.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Text(
                      'Qr invalido',
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
          ),
        ),
        ]
      );
    }
    
  }
}