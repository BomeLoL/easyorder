import 'package:easyorder/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/views/menu.dart';


class Escanear extends StatefulWidget {
  const Escanear({super.key});

  @override
  State<Escanear> createState() => _EscanearState();
}

class _EscanearState extends State<Escanear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("EasyOrder",
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
        //backgroundColor: Colors.white,
      ),
      body: Center(
        child:Container(
          // height: double.infinity,
          // width: double.infinity,
          child: ElevatedButton(
            onPressed: ()async{
              String info=await scannerQr();
              if (mounted && info!="-1") {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return Menu(info: info);}));
              }
              },
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5F04),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
              ),
            minimumSize: Size(200, 60),
            ),
            child: Text("Escanear",style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
        ),
        ),
    );
  }
}

