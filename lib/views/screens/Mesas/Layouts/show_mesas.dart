import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/screens/Mesas/viewRegisterMesa.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowMesas extends StatefulWidget {
  const ShowMesas({super.key, required this.restauranteController, required this.mesa});
  final restauranteController;
  final mesa;

  @override
  State<ShowMesas> createState() => _ShowMesasState();
}

class _ShowMesasState extends State<ShowMesas> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight + MediaQuery.of(context).size.height * 0.07,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.49,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      children: List.from(widget.mesa.map((mesa) {
                        return Column(
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                final tester = await MongoDatabase.Test();
                                if (tester == false) {
                                  // ignore: use_build_context_synchronously
                                  dbErrorDialog(context);
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RegistroMesa(
                                      idMesa: mesa.id,
                                      idRestaurante: widget.restauranteController.restaurante!.id,
                                    );
                                  }));
                                }
                              },
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(300, 50),
                                side: BorderSide(color: Color(0xFFFF5F04), width: 2),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      })
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
