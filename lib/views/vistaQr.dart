import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../views/Widgets/scanned_barcode_label.dart';
import '../views/Widgets/scanner_error_widget.dart';
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
  QrController qrController = QrController();
 @override
Widget build(BuildContext context) {
  
  final scanWindow = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 300,
    height: 300,
  );

  return Scaffold(
    backgroundColor: Colors.black,
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      iconTheme: IconThemeData(color:Colors.white),
      backgroundColor: Colors.black,
       ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: MobileScanner(
            fit: BoxFit.contain,
            controller: controller,
            scanWindow: scanWindow,
            errorBuilder: (context, error, child) {
              // pedirPermiso();
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
                int continuarOerror = await qrController.revisarBd(barcode.barcodes, context);
                if (continuarOerror == 1) {
                  setState(() {
                    tipo=1;
                  });
                }else if (continuarOerror == 2) {
                  setState(() {
                    tipo=2;
                  });                }
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

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}