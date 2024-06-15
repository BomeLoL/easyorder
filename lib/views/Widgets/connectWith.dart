import 'package:easyorder/views/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectWith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
        color: Colors.white,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 4,
                width: size.width * 0.2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.orange.withOpacity(0.0),
                      Colors.orange.withOpacity(0.2),
                      Colors.orange.withOpacity(0.5),
                      Colors.orange.withOpacity(1),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "o conéctate con",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 4,
                width: size.width * 0.2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.orange.withOpacity(1),
                      Colors.orange.withOpacity(0.5),
                      Colors.orange.withOpacity(0.2),
                      Colors.orange.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
