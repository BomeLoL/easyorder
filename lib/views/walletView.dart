import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/navigationBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class walletView extends StatefulWidget {
  const walletView({super.key});
  @override
  State<walletView> createState() => _walletViewState();
}

class _walletViewState extends State<walletView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true, 
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.9,
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
                              Container(alignment: Alignment.center,  child: Text("Billetera",style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 32),)),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05
                                      ),
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
                                  )
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 25,),
                                    Text("Tu saldo", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                                    SizedBox(height: 15,),
                                    Text("\$20.0", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white),),
                                  ],
                                  ),
                                )
                              ),
                              
                            ]),
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
                        )
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Text("Introduzca la cantidad de fondos que desea añadir", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),textAlign: TextAlign.center,),
                          SizedBox(height: 10,),
                          SizedBox(
                            width: 300,
                            child: Column(
                              children: [
                              Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(255, 95, 4, 1 ), width: 2),
                                  ),
                                  hintText: "monto",
                                  hintStyle: GoogleFonts.poppins(fontSize: 14)
                              ),
                              style: GoogleFonts.poppins(fontSize: 14,),
                              cursorColor: Color.fromRGBO(255, 95, 4, 1 ),
                              
                            ),
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                ),
                              minimumSize: Size(300, 50)
                            ), 
                            child: Text("Añadir Fondos", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color:Color(0xFFFF5F04) ) ,)
                            )
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
        bottomNavigationBar: BarNavigation(),
        // BottomNavigationBar(
        //   items: [
        //     BottomNavigationBarItem(
        //             icon: Icon(
        //               Icons.qr_code,
        //               size: 45.0,
        //               color: Color.fromRGBO(255, 95, 4, 1),
        //             ),
        //             label: "Escanear",
        //           ),
        //           BottomNavigationBarItem(
        //             icon: Icon(
        //               Icons.exit_to_app,
        //               size: 45.0,
        //               color: Color.fromRGBO(255, 95, 4, 1),
        //             ),
        //             label: "Terminar sesión",
        //           )
        //   ],
        // ),
        ),
    );
  }
}