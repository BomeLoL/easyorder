import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';




class RegistroMesa extends StatefulWidget {
  const RegistroMesa({super.key});

  @override
  State<RegistroMesa> createState() => _RegistroMesaState();
}

class _RegistroMesaState extends State<RegistroMesa> {
  final GlobalKey _qrKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  Future<Image>? image;

  int numMesa = 1;
  int idRestaurante = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "Registrar Mesa",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.9,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                            top: 50,
                            right: 16,
                            left: 16,
                          ),
                  child: Column(
                    children: [
                      Text(
                        "Ingrese el numero de identificación de la mesa *",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      SizedBox(height: 20),
          
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          color: Colors.black),
                        cursorColor: Color.fromRGBO(255, 95, 4, 1),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 95, 4, 1),
                              width: 2,
                            )
                          ),
                        hintText: "Ej. 5",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black38)
                        ),
                      ),
                      SizedBox(height: 60,),
                      Container(
                        child: RepaintBoundary(
                          key: _qrKey,
                          child: QrImageView(
                            data: idRestaurante.toString() + ',' + numMesa.toString(),
                            version: QrVersions.auto,
                            size: 270,
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
                  )
                ),
                //botones de abajo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),),
                              side: BorderSide(
                                color: Color(0xFFFF5F04),
                              ),
                              minimumSize: Size(165, 50)
                            ), 
                            child: Text("Cancelar",
                              style:GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5F04)), 
                            ),
                            ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF5F04),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),),
                              minimumSize: Size(165, 50)
                            ), 
                            child: Text("Guardar",
                              style:GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white), 
                            ),
                            ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
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