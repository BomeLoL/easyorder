import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';


class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'El controlador para usar la cámara no esta listo';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'No se obtuvo permiso para usar la cámara';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'El dispositivo no es capaz de escanear';
      default:
        errorMessage = 'Error';
        break;
    }

    if (errorMessage=='No se obtuvo permiso para usar la cámara') {
      return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                onPressed:(){
                  Navigator.pop(context);
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                  ),
                minimumSize: Size(60, 30),
                ), 
                child: Text("Cancelar",
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
                )
                ),
                ElevatedButton(
                onPressed:(){
                  openAppSettings();
                  Navigator.pop(context);
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                  ),
                minimumSize: Size(60, 30),
                ), 
                child: Text("Otorgar permiso",
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
                )
                ),
              ],
            )
          ],
        ),
      ),
    );
    } else {
      return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
    }
    
  }
}