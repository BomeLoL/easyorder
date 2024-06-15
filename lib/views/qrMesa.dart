import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

class qrMesa extends StatefulWidget {
  const qrMesa({super.key});

  @override
  State<qrMesa> createState() => _qrMesaState();
}

class _qrMesaState extends State<qrMesa> {
  int numMesa = 1;
  int idRestaurante = 1;
  final GlobalKey _qrKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  dynamic externalDir = '/storage/emulated/0/Download/Codigos_QR';
  bool dirExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "QR de la Mesa #" + numMesa.toString(),
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _captureAndSaveQR,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5F04),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(200, 60),
              ),
              child: Text(
                "Descargar QR",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: RepaintBoundary(
                key: _qrKey,
                child: QrImageView(
                  data: idRestaurante.toString() + ',' + numMesa.toString(),
                  version: QrVersions.auto,
                  size: 200,
                  errorStateBuilder: (ctx, err) {
                    return const Center(
                      child: Text(
                        "Algo salio mal",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndSaveQR() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);

      //Se dibuja un fondo blanco debido a que el QR es de color negro y esto se va a descargar como un png transparente
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);

      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      String filename = 'qr_code_mesa_${numMesa}';
      int i = 1;
      while (await File('${externalDir}/${filename}.png').exists()) {
        filename = 'qr_code_mesa_${numMesa}(${i})';
        i++;
      }

      //Revisa si el directorio existe o no
      dirExists = await File(externalDir).exists();
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('${externalDir}/${filename}.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      const Snackbar = SnackBar(
          content: Text(
              'El código QR se ha guardado correctamente a su dispositivo'));
      ScaffoldMessenger.of(context).showSnackBar(Snackbar);
    } catch (e) {
      print(e);
      const Snackbar =
          SnackBar(content: Text('Ha ocurrido un problema guardando el QR'));
      ScaffoldMessenger.of(context).showSnackBar(Snackbar);
    }
  }
}
