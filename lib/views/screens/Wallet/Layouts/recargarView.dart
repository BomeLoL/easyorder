import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class Recargarview extends StatefulWidget {
  const Recargarview(
      {super.key,
      required this.controller,
      required this.saldo,
      required this.userController,
      required this.auth,
      required this.onSaldoChanged});
  final controller;
  final saldo;
  final userController;
  final auth;
  final Function(double) onSaldoChanged;

  @override
  State<Recargarview> createState() => _RecargarviewState();
}

class _RecargarviewState extends State<Recargarview> {
  bool vacio = false;
  double saldo = 0;
  @override
  void initState() {
    super.initState();
    saldo = widget.saldo;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 95, 4, 1),
                Colors.red,
              ],
            )),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Introduzca la cantidad de fondos que desea añadir",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: vacio,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "No puede dejar el campo vacío",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      controller: widget.controller,
                      textAlign: TextAlign.center,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(255, 95, 4, 1), width: 2),
                        ),
                        hintText: "Monto",
                        hintStyle: GoogleFonts.poppins(fontSize: 14),
                        contentPadding: EdgeInsets.all(12),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                      cursorColor: Color.fromRGBO(255, 95, 4, 1),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      //Aqui empieza la funcion de Paypalx
                      onPressed: () async {
                        if (widget.controller.text.isEmpty) {
                          setState(() {
                            vacio = true;
                          });
                        } else if (double.parse(widget.controller.text) <= 0) {
                        } else {
                          setState(() {
                            vacio = false;
                          });
                          await Paypal(context);
                        }
                        ;
                      },

                      //Termina la funcion de Paypal
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(300, 50)),
                      child: Text(
                        "Añadir Fondos",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFFFF5F04)),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> Paypal(BuildContext context) async{
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AdJI5Tcd3A88s_8hcvMaIYFrUyn0_KHmPjAiXjRLugFN99VEUZWA5hqaiLih5YJhxLZQw8Du8FKvjYUp",
            secretKey:
                "EPZCyx3KXP8YH64EkrX51_YNO5qg6l-r8QZh8DGd1TaNJnp1Q3nIRscEQjwBVNVr_12voUp9OIthSvDQ",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": widget.controller.text,
                  "currency": "USD",
                },
                "description": "Añadir fondos a tu cuenta de EasyOrder.",
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              if (mounted) {
                setState(() {
                saldo = saldo + double.parse(widget.controller.text);
              });
              widget.controller.clear();
              widget.onSaldoChanged(saldo);
              }
              
              

              if (widget.userController.usuario != null) {
                widget.userController.usuario!.saldo = saldo;
                widget.auth.updateUser(widget.userController.usuario!);
              }
              if (widget.userController.usuario != null &&
                  widget.userController.usuario!.correo != null &&
                  widget.userController.usuario!.cuenta != null) {
                var updateChangesUser =
                    await widget.auth.getUserByEmailAndAccount(
                  widget.userController.usuario!.correo!,
                  widget.userController.usuario!.cuenta!,
                );
                if (mounted) {
                  widget.userController.usuario = updateChangesUser;
                }
                
              }
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
  }
}
