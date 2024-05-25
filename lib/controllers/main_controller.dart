import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future <String> scannerQr()async{
  String barcodeScanRes;
  // final currentContext = context;
  try{
     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", 
      "Salir", 
      false, 
      ScanMode.QR);
      
    return barcodeScanRes;
  } on PlatformException {
      //exit(0);
      barcodeScanRes= "-1";
  
  }
  return "";

}

