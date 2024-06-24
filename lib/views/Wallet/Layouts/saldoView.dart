import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Saldoview extends StatefulWidget {
  const Saldoview({super.key, required this.saldo});
  final String saldo;

  @override
  State<Saldoview> createState() => _SaldoviewState();
}

class _SaldoviewState extends State<Saldoview> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          right: 5,
          left: 5,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Billetera",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      '\$' + widget.saldo.toString(),
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
    );
  }
}
