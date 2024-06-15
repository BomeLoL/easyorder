import 'dart:io';

import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

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
  Future<Image>? image;

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
    } catch (e) {
      print(e);
    }
  }
}
