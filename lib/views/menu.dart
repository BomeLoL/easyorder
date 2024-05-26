import 'package:easyorder/views/Widgets/Product_Card_Init.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.info});
  final String info;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String infoQr = "";

  int botonIndice = 0;
  List<int> botones = [0, 1, 2]; //se deberia tener un numero por cada categoria
  Color colorBoton1 = Color(0xFFFF5F04);
  //Color colorBoton2=Colors.white;
  @override
  void initState() {
    super.initState();
    infoQr = widget.info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      //appBar: PreferredSize(
      //  preferredSize: Size.fromHeight(kToolbarHeight),
      //  child: Stack(
      //    children: [
      //      Container(
      //        width: double.infinity,
      //        height: double.infinity,
      //        decoration: BoxDecoration(
      //          image: DecorationImage(
      //            image: AssetImage('images/fruits.png'),
      //            fit: BoxFit.cover,
      //            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.dstATop),
      //          ),
      //        ),
      //      ),
      //      AppBar(
      //      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      //      scrolledUnderElevation: 0,
      //      centerTitle: true,
      //      title: Text(infoQr, //tecnicamente infoQr tendra info que debera separarse, en esta parte iria el nombre del restaurante
      //      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      //      ),
      //    ),
      //  ]
      //  ),
      //),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
      ),
      body: Background_image(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: kToolbarHeight + 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Menú del Restaurante",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(20),
              Container(
                width: double.infinity,
                height: 50,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            botonIndice = 0;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: botonIndice == 0
                              ? Color(0xFFFF5F04)
                              : Colors.white,
                          foregroundColor:
                              botonIndice == 0 ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size(45, 40),
                        ),
                        child: Text("Parrilla Guanteña"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              botonIndice = 1;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: botonIndice == 1
                                ? Color(0xFFFF5F04)
                                : Colors.white,
                            foregroundColor:
                                botonIndice == 1 ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(45, 40),
                          ),
                          child: Text("Parrilla Caraqueña")),
                      SizedBox(width: 10),
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              botonIndice = 2;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: botonIndice == 2
                                ? Color(0xFFFF5F04)
                                : Colors.white,
                            foregroundColor:
                                botonIndice == 2 ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(45, 40),
                          ),
                          child: Text("Postre")),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    botonIndice == 0
                        ? ProductCardInit(
                            productName: "Parrilla con platano",
                            productPrice: 15.8,
                            productImage:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZs4XdR6VDF8inuMgk5_rLDBdQF7pVv4-b6Y63nyUF0g&s")
                        : botonIndice == 1
                            ? ProductCardInit(
                                productName: "Parrilla sin platano",
                                productPrice: 14.0,
                                productImage:
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI0vuP2m3JkbwjczFfZwIxqAy8Ub55p1lw7rtSiREp1A&s")
                            : ProductCardInit(
                                productName: "Quesillo",
                                productPrice: 6.0,
                                productImage:
                                    "https://mmedia.estampas.com/18856/quesillo-sin-huequitos-81792.jpg")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          fixedColor: Color.fromRGBO(142, 142, 142, 1),
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code,
                size: 45.0,
                color: Color.fromRGBO(255, 95, 4, 1),
              ),
              label: "Scan",
            )
          ]),
    );
  }
}
