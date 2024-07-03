import 'dart:io';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:image/image.dart' as img;

extension PrettyQrImageExtension on QrImage {
  Future<String?> exportAsImage(
    final BuildContext context, {
    required final int size,
    required PrettyQrDecoration decoration,
    required idmesa,
    required nomrestaurante
  }) async {
    dynamic externalDirPath = '/storage/emulated/0/Codigos_QR';
    final externalDir = Directory(externalDirPath);

    try {
      // Verificar si el directorio existe, si no, crearlo de manera recursiva
      if (!await externalDir.exists()) {
        await externalDir.create(recursive: true);
      }

      final configuration = createLocalImageConfiguration(context);

      final bytes = await toImageAsBytes(
        size: size,
        decoration: decoration,
        configuration: configuration,
      );


      img.Image? qrImage = img.decodeImage(bytes!.buffer.asUint8List());

      // Crear una imagen en blanco
      final padding = 20;
      final paddedImage = img.Image( width:qrImage!.width + padding * 2, height: qrImage.height + padding * 2);
      img.fill(paddedImage, color: img.ColorRgb8(255,255,255));

      // Pegar la imagen QR en el centro de la imagen en blanco
      img.compositeImage(paddedImage, qrImage, dstX: padding, dstY: padding);
      
      final paddedBytes = img.encodePng(paddedImage);


      // Nombre del archivo a guardar
      final fileName = '${nomrestaurante}_qr_mesa_${idmesa}.png';
      final filePath = '${externalDir.path}/$fileName';
      final file = File(filePath);

      // Verificar y eliminar el archivo existente, si lo hay
      if (await file.exists()) {
        await file.delete();
      }

      // Escribir los bytes del QR en el archivo
      await file.writeAsBytes(Uint8List.fromList(paddedBytes));

      return filePath;
    } catch (e) {
      print('Error al exportar imagen QR como archivo: $e');
      return null;
    }
  }
}

Future<PermissionStatus> Pedir_permiso(BuildContext context) async {
  var permissionGranted;
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Permiso para descargar",
          style: GoogleFonts.poppins(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Text(
          "Se requiere acceso a los archivos de su dispositivo",
          style: GoogleFonts.poppins(
            fontSize: 15.0,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              permissionGranted = await Permission.manageExternalStorage.status.isGranted;
            },
            child: Text(
              'Salir',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(100, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await Permission.manageExternalStorage.request();
              permissionGranted = await Permission.manageExternalStorage.status.isGranted;
              Navigator.pop(context);
            },
            child: Text(
              'Otorgar permiso',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: Size(100, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      );
    },
  );

  return permissionGranted;
}


