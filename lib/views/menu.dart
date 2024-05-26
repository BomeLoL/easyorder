import 'package:easyorder/views/Widgets/Product_Card_Init.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.info});
  final String info;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String infoQr="";

  int botonIndice=0;
  List <int> botones=[0,1,2]; //se deberia tener un numero por cada categoria
  Color colorBoton1=Color(0xFFFF5F04);
  //Color colorBoton2=Colors.white;
    @override
  void initState() {
    super.initState();
    infoQr = widget.info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(infoQr, //tecnicamente infoQr tendra info que debera separarse, en esta parte iria el nombre del restaurante
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("Menú del Restaurante", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold,)),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity, // Ancho máximo disponible
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                  children: [
                    SizedBox( width: 15,),
                    OutlinedButton(
                      onPressed: (){
                        setState(() {
                          botonIndice=0;
                        });
                      }, 
                      style: OutlinedButton.styleFrom(
                        backgroundColor: botonIndice==0? Color(0xFFFF5F04):Colors.white,
                        foregroundColor: botonIndice==0? Colors.white:Colors.black,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)  
                          ),
                        minimumSize: Size(45, 40),   
                      ),
                      child: Text("Parrilla Guanteña"), 
                      ),
                    SizedBox(width: 10,),
                    OutlinedButton(onPressed: (){
                      setState(() {
                        botonIndice=1;
                      });
                    }, 
                    style: OutlinedButton.styleFrom(
                      backgroundColor: botonIndice==1? Color(0xFFFF5F04):Colors.white,
                      foregroundColor: botonIndice==1? Colors.white:Colors.black ,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)  
                      ),
                      minimumSize: Size(45, 40),   
                    ),
                    child: Text("Parrilla Caraqueña")),
                    SizedBox(width: 10,),
                    OutlinedButton(onPressed: (){
                      setState(() {
                        botonIndice=2;
                      });
                    }, 
                    style: OutlinedButton.styleFrom(
                      backgroundColor: botonIndice==2? Color(0xFFFF5F04):Colors.white,
                      foregroundColor: botonIndice==2? Colors.white:Colors.black ,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)  
                      ),
                      minimumSize: Size(45, 40),   
                    ),
                    child: Text("Postre")),
                    SizedBox(width: 10,),
                  ],
                ),
              ]),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    botonIndice==0?
                      ProductCardInit(
                      productName: "Parrilla con platano", 
                      productPrice: 15.8, 
                      productImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZs4XdR6VDF8inuMgk5_rLDBdQF7pVv4-b6Y63nyUF0g&s"
                      )
                    : botonIndice==1? 
                      ProductCardInit(
                      productName: "Parrilla sin platano", 
                      productPrice: 14.0, 
                      productImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI0vuP2m3JkbwjczFfZwIxqAy8Ub55p1lw7rtSiREp1A&s")
                    : ProductCardInit(
                      productName: "Quesillo", 
                      productPrice: 6.0, 
                      productImage: "https://mmedia.estampas.com/18856/quesillo-sin-huequitos-81792.jpg")
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 45.0,
            color: Color(0xFFFF0000).withOpacity(0.5),
            ),
          label: "Home",
          ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code,
            size: 45.0,
            color: Color(0xFFFF0000).withOpacity(0.5),
            ),
          label: "Scan",
          )
      ]
      ),
    );
  }
}