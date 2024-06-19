import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/navigationBarClient.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:provider/provider.dart';

class walletView extends StatefulWidget {
  const walletView({super.key,
      required this.info,
      required this.restaurante,
      required this.idMesa});
      
  final String info;
  final Restaurante restaurante;
  final int idMesa;
  
  @override
  State<walletView> createState() => _walletViewState();
}

class _walletViewState extends State<walletView> {
  final myController = TextEditingController();
  double saldo = 0;
  bool vacio=false;
  final _auth = Authservice();
  

  @override
  Widget build(BuildContext context) {
    UserController userController = Provider.of<UserController>(context, listen: false);
    if (userController.usuario?.saldo != null && userController.usuario!.saldo is double) {
      saldo = userController.usuario!.saldo!;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Background_image(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 5,
                      left: 5,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                      height:MediaQuery.of(context).size.height * 0.07),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Billetera",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                height: 180,
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
                                      height: 25,
                                    ),
                                    Text(
                                      "Tu saldo",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '\$' + saldo.toString(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 50,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
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
                            padding: EdgeInsets.symmetric( horizontal: 8),
                            child: Text(
                              "No puede dejar el campo vacío",
                              style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white),
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
                                  controller: myController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(255, 95, 4, 1),
                                            width: 2),
                                      ),
                                      hintText: "Monto",
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 14),
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

                                    if (myController.text.isEmpty) {
                                      setState(() {
                                        vacio=true;
                                      });
                                    } else if (double.parse(
                                            myController.text) <=
                                        0) {
                                    } else {
                                      setState(() {
                                        vacio=false;
                                      });
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              UsePaypal(
                                                  sandboxMode: true,
                                                  clientId:
                                                      "AdJI5Tcd3A88s_8hcvMaIYFrUyn0_KHmPjAiXjRLugFN99VEUZWA5hqaiLih5YJhxLZQw8Du8FKvjYUp",
                                                  secretKey:
                                                      "EPZCyx3KXP8YH64EkrX51_YNO5qg6l-r8QZh8DGd1TaNJnp1Q3nIRscEQjwBVNVr_12voUp9OIthSvDQ",
                                                  returnURL:
                                                      "https://samplesite.com/return",
                                                  cancelURL:
                                                      "https://samplesite.com/cancel",
                                                  transactions: [
                                                    {
                                                      "amount": {
                                                        "total":
                                                            myController.text,
                                                        "currency": "USD",
                                                      },
                                                      "description":
                                                          "Añadir fondos a tu cuenta de EasyOrder.",
                                                    }
                                                  ],
                                                  note:
                                                      "Contact us for any questions on your order.",
                                                  onSuccess:
                                                      (Map params) async {
                                                    print("onSuccess: $params");
                                                    setState(() {
                                                      saldo = saldo +
                                                          double.parse(
                                                              myController
                                                                  .text);
                                                    });
                                                    myController.clear();


                                                  if (userController.usuario != null) {
                                                    userController.usuario!.saldo = saldo;
                                                    _auth.updateUser(userController.usuario!);
                                                  }                                     
                                                    if (userController.usuario != null && 
                                                      userController.usuario!.correo != null && 
                                                      userController.usuario!.cuenta != null) {
                                                      var updateChangesUser = await _auth.getUserByEmailAndAccount(
                                                      userController.usuario!.correo!,
                                                      userController.usuario!.cuenta!,
                                                    );
                                                    userController.usuario = updateChangesUser;
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
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BarNavigationClient(idMesa: widget.idMesa,info: widget.info,restaurante: widget.restaurante),
    );
}
}