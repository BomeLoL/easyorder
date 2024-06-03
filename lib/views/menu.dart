import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/detallePedido.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key, required this.info, required this.menu, required this.restaurante, required this.idMesa});
  final String info;
  final Menu menu; 
  final Restaurante restaurante;
  final int idMesa; 

  @override
  State<MenuView> createState() => _MenuState();
}

class _MenuState extends State<MenuView> {
  String nombreRes = "";
  Set <String> categorias= Set <String>();
  int selectedIndex = -1;
  String selectedCategoria = "Todo";
  Color colorBoton1 = Color(0xFFFF5F04);
  
  @override
  
  void initState() {
    super.initState();
    nombreRes = widget.restaurante.nombre;
    categorias.add("Todo");
    for (var elemento in widget.menu.itemsMenu) {
    categorias.add(elemento.categoria);
    }
    selectedCategoria = "Todo";
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(nombreRes,
           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
           ),
      ),
      body: Background_image(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: 16,
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: kToolbarHeight + MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Menú del Restaurante",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
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
                        children: categorias.map(
                          (elemento){
                            Color color = elemento == selectedCategoria ? Color(0xFFFF5F04) : Colors.white;
                            Color color1 = elemento == selectedCategoria ? Colors.white : Colors.black;
                          return [
                          OutlinedButton(
                            onPressed: (){
                              setState(() {
                                selectedCategoria = elemento;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: color1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size(45, 40),
                            ), 
                            child: Text(elemento)
                            ),
                            SizedBox( width: 10,),
                            ];
                          }
                        ).expand((widgets)=> widgets).toList()  
                      ),
                    ]),
                    ),
                    SizedBox(
                    height: 10,
                    ),
                    Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemCount: widget.menu.itemsMenu.length,
                    itemBuilder: (context, index) {
                      if (selectedCategoria == "Todo" || widget.menu.itemsMenu[index].categoria == selectedCategoria) {
                        return Column(
                          children: [
                          ProductCard(producto: widget.menu.itemsMenu[index], isPedido: 1, info: nombreRes),
                          SizedBox(height: 10,)
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }
                    )
                  
                  ),
                    
                    ]
                    ),
                    ),
          ),
          Consumer<CartController>(builder: (context, cartController, child) {
                if (cartController.pedido.productos.isNotEmpty) {
                  final nroProductos =
                      cartController.totalCantidad();
                  return Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                nroProductos.toString() + ' producto(s) en el carrito',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Spacer(flex: 1,),
                          Expanded(
                            flex: 8,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:const Color.fromRGBO(255, 95, 4, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  )
                                  ),
                              onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => detallePedido(info:nombreRes, menu: widget.menu, restaurante: widget.restaurante, idMesa: widget.idMesa)
                                ),
                              );
                          },
                              child: Text(
                                'Ver mi pedido',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              })
        ],
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