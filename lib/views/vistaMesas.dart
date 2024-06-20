import 'package:easyorder/controllers/restaurante_controller.dart';
import 'package:easyorder/models/clases/mesa.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/navigationBarRestaurant.dart';
import 'package:easyorder/views/registro_mesa.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Vistamesas extends StatefulWidget {
  const Vistamesas({super.key, required this.mesa});

  final List<Mesa> mesa;
  @override
  State<Vistamesas> createState() => _VistamesasState();
}

class _VistamesasState extends State<Vistamesas> {
  bool error = false;
  late RestauranteController restauranteController;

  @override
  void initState() {
    super.initState();
    restauranteController =
        Provider.of<RestauranteController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) {
          return route.settings.name == 'menu';
        });

        return await true;
      },
      child: Consumer<RestauranteController>(
        builder: (context, restauranteController, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(0, 255, 255, 255),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text(
                "Mesas registradas",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 16,
                    left: 16,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                            height: kToolbarHeight +
                                MediaQuery.of(context).size.height * 0.07),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.49,
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              children: widget.mesa.map((mesa) {
                                return Column(
                                  children: [
                                    OutlinedButton(
                                      onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return RegistroMesa(
                                            idMesa: mesa.id,
                                            idRestaurante: restauranteController
                                                .restaurante!.id,
                                          );
                                        }));
                                      }},
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Mesa ${mesa.id}",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            Icon(Icons.qr_code, color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        minimumSize: Size(300, 50),
                                        side: BorderSide(
                                            color: Color(0xFFFF5F04), width: 2),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                ElevatedButton(
                  onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                    await _showConfirmationDialog(context);
                    if (error == true) {
                      _errorDialog(context);
                    }
                  }},
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
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                      widget.mesa
                          .add(Mesa(id: widget.mesa.length + 1, pedidos: []));
                      restauranteController.addMesa(
                          widget.mesa, restauranteController.restaurante!);
                    }}, //ayuda de kevin para conectar con BD
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5F04),
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
                ),
              ],
            ),
            bottomNavigationBar: BarNavigationRestaurant(),
          );
        },
      ),
    );
    //});
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
                            restauranteController.deleteMesa(widget.mesa,
                                restauranteController.restaurante!);
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
}
