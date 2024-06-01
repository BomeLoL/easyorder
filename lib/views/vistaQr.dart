import 'package:easyorder/views/escaneoQR.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
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

  int tipo=0;

  Future<void> pedirPermiso(error) async{
    final status = Permission.camera.status;
    if (await status.isDenied || await status.isPermanentlyDenied) {
       showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title:Text('Permisos de cámara',
        style: GoogleFonts.poppins(),),
        content:Text(
          'Necesitamos acceso a la cámara para escanear códigos Qr. Por favor, otorga los permisos en la configuración de la aplicación.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return Escanear();} ));
              },
            child:Text('Cancelar',
            style: GoogleFonts.poppins(
                    color: Color.fromRGBO(255, 96, 4, 1),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
          ),
          TextButton(
            onPressed: () async {
              openAppSettings();
              Navigator.pop(context); 
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return Escanear();} ));
              },
            child:Text('Otorgar permiso',
            style: GoogleFonts.poppins(
                    color: Color.fromRGBO(255, 96, 4, 1),
                    fontWeight: FontWeight.bold,
                  ),
            ),
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
                  child: ScannedBarcodeLabel(barcodes: controller.barcodes, tipo: tipo,),
                ),
              );
            },
            onDetect: (barcode)async{
              if(barcode.barcodes.isNotEmpty){
                // bool continuar;
                bool continuar = await RevisarBd(barcode.barcodes, context);
                if (!continuar) {
                  setState(() {
                    tipo=1;
                  });
                }
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

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}