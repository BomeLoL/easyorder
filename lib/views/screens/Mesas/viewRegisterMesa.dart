import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

class RegistroMesa extends StatefulWidget {
  const RegistroMesa(
      {super.key, required this.idMesa, required this.idRestaurante});

  final int idMesa;
  final String idRestaurante;

  @override
  State<RegistroMesa> createState() => _RegistroMesaState();
}

class _RegistroMesaState extends State<RegistroMesa> {
  final GlobalKey _qrKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  dynamic externalDir = '/storage/emulated/0/Download/Codigos_QR';
  bool dirExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "Mesa ${widget.idMesa}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              right: 16,
              left: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Qr asociado a la mesa",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: buildQrCode(),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _captureAndSaveQR,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5F04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(320, 50)),
                  child: Container(
                    width: 270,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Descargar",
                          style: GoogleFonts.poppins(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.file_download_outlined,
                          color: Colors.white,
                          size: 27,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
          //botones de abajo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35.0),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: Color(0xFFFF5F04),
                    ),
                    minimumSize: Size(320, 50)),
                child: Text(
                  "Volver",
                  style: GoogleFonts.poppins(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5F04)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //se crea el qr de la mesa
  Widget buildQrCode() {
    return RepaintBoundary(
      key: _qrKey,
      child: QrImageView(
        data: '${widget.idRestaurante},${widget.idMesa}',
        version: QrVersions.auto,
        size: 270,
        errorStateBuilder: (ctx, err) {
          return const Center(
            child: Text(
              "Algo salió mal",
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  //se descarga la imagen
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

      String filename = 'qr_code_mesa_${widget.idMesa}';
      int i = 1;
      while (await File('${externalDir}/${filename}.png').exists()) {
        filename = 'qr_code_mesa_${widget.idMesa}(${i})';
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
