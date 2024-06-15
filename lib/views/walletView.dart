import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class walletView extends StatefulWidget {
  const walletView({super.key});

  @override
  State<walletView> createState() => _walletViewState();
}

class _walletViewState extends State<walletView> {
  final myController = TextEditingController();
  double saldo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                      top: 70,
                      right: 5,
                      left: 5,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                    height: 200,
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
                        SizedBox(
                          height: 10,
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
                                          GoogleFonts.poppins(fontSize: 14)),
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
                                    } else if (double.parse(
                                            myController.text) <=
                                        0) {
                                    } else {
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code,
              size: 45.0,
              color: Color.fromRGBO(255, 95, 4, 1),
            ),
            label: "Escanear",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.exit_to_app,
              size: 45.0,
              color: Color.fromRGBO(255, 95, 4, 1),
            ),
            label: "Terminar sesión",
          )
        ],
      ),
    );
  }
}
