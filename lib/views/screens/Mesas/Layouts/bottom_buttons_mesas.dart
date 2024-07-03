import 'package:easyorder/controllers/download_controller.dart';
import 'package:easyorder/models/clases/mesa.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class BottomButtonsMesas extends StatefulWidget {
  const BottomButtonsMesas({
    super.key,
    required this.restauranteController,
    required this.mesa,
  });
  final restauranteController;
  final mesa;

  @override
  State<BottomButtonsMesas> createState() => _BottomButtonsMesasState();
}

class _BottomButtonsMesasState extends State<BottomButtonsMesas> {
  bool error = false;

  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;

  @protected
  late PrettyQrDecoration decoration;

  void initState() {
    super.initState();

    qrCode = QrCode.fromData(
      data: '${widget.restauranteController.restaurante!.id},1',
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
    return Column(
      children: [
        Gap(20),
        ElevatedButton(
          onPressed: () async {
            final tester = await MongoDatabase.Test();
            if (tester == false) {
              // ignore: use_build_context_synchronously
              dbErrorDialog(context);
            } else {
              await _showConfirmationDialog(context);
              if (error == true) {
                _errorDialog(context);
              }
            }
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
            "Eliminar mesa",
            style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5F04)),
          ),
        ),
        Gap(20),
        ElevatedButton(
          onPressed: () async {
            final tester = await MongoDatabase.Test();
            if (tester == false) {
              // ignore: use_build_context_synchronously
              dbErrorDialog(context);
            } else {
              widget.mesa.add(Mesa(id: widget.mesa.length + 1, pedidos: []));
              widget.restauranteController.addMesa(
                  widget.mesa, widget.restauranteController.restaurante!);
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(320, 50)),
          child: Text(
            "Registrar mesa",
            style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        Gap(20),
        ElevatedButton(
          onPressed: () async {
            var status = await Permission.manageExternalStorage.status;
            if (status.isDenied) {
              status = await Pedir_permiso(context);
            }
            if (status.isGranted) {
              var path;
              for (var i = 0; i < widget.mesa.length; i++) {
                setState(() {
                  qrCode = QrCode.fromData(
                      data:
                          '${widget.restauranteController.restaurante!.id},${i + 1}',
                      errorCorrectLevel: QrErrorCorrectLevel.H);
                  qrImage = QrImage(qrCode);
                });
                path = await qrImage.exportAsImage(context,
                    size: 512,
                    decoration: decoration,
                    idmesa: i + 1,
                    nomrestaurante: widget.restauranteController.restaurante!.nombre);
                showExportPath(path);
                //espera dos segundos para descargar el siguiente
                await Future.delayed(Duration(seconds: 2));
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Descarga exitosa")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(320, 50)),
          child: Text(
            "Descargar todos los códigos QR",
            style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        Gap(20)
      ],
    );
  }

  void _errorDialog(BuildContext context) {
    showCustomPopup(
      pop: false,
      context: context,
      title: 'Error',
      content: const Text(
        'No puede eliminar todas las mesas de su restaurante',
        textAlign: TextAlign.justify,
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Aquí se corrige la llamada a pop
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: const Color.fromRGBO(255, 96, 4, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                '¿Desea eliminar una mesa?',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Se eliminará la última mesa registrada',
                textAlign: TextAlign.justify,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          error = false;
                        });
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.poppins(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (widget.mesa.length == 1) {
                            error = true;
                            print('No puedes eliminar todas tus mesas!');
                          } else {
                            error = false;
                            widget.mesa.removeLast();
                            widget.restauranteController.deleteMesa(widget.mesa,
                                widget.restauranteController.restaurante!);
                          }
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                      child: Text(
                        'Confirmar',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
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
