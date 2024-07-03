import 'package:easyorder/controllers/download_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';


class RegistroMesa extends StatefulWidget {
  const RegistroMesa(
      {super.key, required this.idMesa, required this.idRestaurante, required this.nomRestaurante});

  final int idMesa;
  final String idRestaurante;
  final String nomRestaurante;

  @override
  State<RegistroMesa> createState() => _RegistroMesaState();
}

class _RegistroMesaState extends State<RegistroMesa> {
  ScreenshotController screenshotController = ScreenshotController();
  dynamic externalDir = '/storage/emulated/0/Download/Codigos_QR';
  bool dirExists = false;

  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;

  @protected
  late PrettyQrDecoration decoration;

    void initState() {
    super.initState();

    qrCode = QrCode.fromData(
      data: '${widget.idRestaurante},${widget.idMesa}',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);

    decoration = const PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(
        color: Colors.black,
        roundFactor: 0, 
        ),
      background: Colors.white,
      );
  }

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
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: PrettyQrView(qrImage: qrImage, decoration: decoration,),
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: ()async{
                    var status = await Permission.manageExternalStorage.status;
                    var path;
                    if (status.isDenied) {
                      status = await Pedir_permiso(context);
                    }

                    if (status.isGranted) {
                      path = await qrImage.exportAsImage(
                        context, 
                        size: 512, 
                        decoration: decoration, 
                        idmesa: widget.idMesa, 
                        nomrestaurante: widget.nomRestaurante); 
                        showExportPath(path);
                    }
                  }, 
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

    @protected
  void showExportPath(String? path) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(path == null ? 'Saved' : 'Saved to $path')),
    );
  }
}
