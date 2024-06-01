import 'package:easyorder/views/escaneoQR.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../views/Widgets/scanned_barcode_label.dart';
import '../views/Widgets/scanner_error_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easyorder/views/menu.dart';
import 'package:easyorder/controllers/qr_controller.dart';


class BarcodeScannerWithOverlay extends StatefulWidget {
  const BarcodeScannerWithOverlay({super.key});

  @override
  _BarcodeScannerWithOverlayState createState() =>
      _BarcodeScannerWithOverlayState();
}

class _BarcodeScannerWithOverlayState extends State<BarcodeScannerWithOverlay> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  Future<void> pedirPermiso(error) async{

    final status = Permission.camera.status;
    if (await status.isDenied || await status.isPermanentlyDenied) {
       showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos de cámara'),
        content: const Text(
          'Necesitamos acceso a la cámara para escanear códigos Qr. Por favor, otorga los permisos en la configuración de la aplicación.',
        ),
        actions: [
          TextButton(
            onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return Escanear();} ));},
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); 
              openAppSettings();
              },
            child: const Text('Otorgar permiso'),
          ),
        ],
      ),
    );

    }
  }

 @override
Widget build(BuildContext context) {
  
  final scanWindow = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 300,
    height: 300,
  );

  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: MobileScanner(
            fit: BoxFit.contain,
            controller: controller,
            scanWindow: scanWindow,
            errorBuilder: (context, error, child) {
              pedirPermiso(error);
              return 
              ScannerErrorWidget(error: error);
            },
            overlayBuilder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment(0.0, -0.6),
                  child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                ),
              );
            },
            onDetect: (barcode){
              if(barcode.barcodes.isNotEmpty) {
                RevisarBd(barcode.barcodes);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Menu(info: barcode.barcodes.first.displayValue as String);
                }));
              }
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            if (!value.isInitialized ||
                !value.isRunning ||
                value.error != null) {
              return const SizedBox();
            }
            return CustomPaint(
              painter: ScannerOverlay(scanWindow: scanWindow),
            );
          },
        ),
      ],
    ),
  );
}

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}