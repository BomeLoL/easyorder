import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _EscanearState();
}

class _EscanearState extends State<Test> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "EasyOrder",
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            onPressed: () async {
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
                      transactions: const [
                        {
                          "amount": {
                            "total": '10.12',
                            "currency": "USD",
                            /*"details": {
                              "subtotal": '10.12',
                              "shipping": '0',
                              "shipping_discount": 0
                            }*/
                          },
                          "description":
                              "Añadir fondos a tu cuenta de EasyOrder.",
                          // "payment_options": {
                          //   "allowed_payment_method":
                          //       "INSTANT_FUNDING_SOURCE"
                          // },
                          /*"item_list": {
                            "items": [
                              {
                                "name": "A demo product",
                                "quantity": 1,
                                "price": '10.12',
                                "currency": "USD"
                              }
                            ],
                          }*/
                        }
                      ],
                      note: "Contact us for any questions on your order.",
                      onSuccess: (Map params) async {
                        print("onSuccess: $params");
                        print("exito");
                      },
                      onError: (error) {
                        print("onError: $error");
                      },
                      onCancel: (params) {
                        print('cancelled: $params');
                      }),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5F04),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: Size(200, 60),
            ),
            child: Text(
              "Añadir fondos",
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
