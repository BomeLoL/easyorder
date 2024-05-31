import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:easyorder/views/menu.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return Container(
            height: 70.0,
            width: 300.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.0),
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
          );
        } else {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Menu(info: scannedBarcodes.first.displayValue ?? '');
        }));
      });
  }

        return Container();
        // Text(
        //   scannedBarcodes.first.displayValue ?? 'No display value.',
        //   overflow: TextOverflow.fade,
        //   style: const TextStyle(color: Colors.white),
        // );
      },
    );
  }
}