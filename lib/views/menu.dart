import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/detallePedido.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.info});
  final String info;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String infoQr = "";
  ItemMenu producto1 = ItemMenu(
      nombreProducto: 'Parrilla con platano',
      precio: 15.1,
      imgUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZs4XdR6VDF8inuMgk5_rLDBdQF7pVv4-b6Y63nyUF0g&s');
  ItemMenu producto2 = ItemMenu(
      nombreProducto: 'Parrilla sin platano',
      precio: 14.0,
      imgUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI0vuP2m3JkbwjczFfZwIxqAy8Ub55p1lw7rtSiREp1A&s');
  ItemMenu producto3 = ItemMenu(
      nombreProducto: 'Quesillo',
      precio: 6.0,
      imgUrl:
          'https://mmedia.estampas.com/18856/quesillo-sin-huequitos-81792.jpg');

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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
      ),
      body: Stack(children: [
        Background_image(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).size.height * 0.03),
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
                              foregroundColor: botonIndice == 1
                                  ? Colors.white
                                  : Colors.black,
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
                              foregroundColor: botonIndice == 2
                                  ? Colors.white
                                  : Colors.black,
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
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      botonIndice == 0
                          ? ProductCard(producto: producto1, isPedido: 1)
                          : botonIndice == 1
                              ? ProductCard(producto: producto2, isPedido: 1)
                              //productName: "Parrilla sin platano",
                              //productPrice: 14.0,
                              //productImage:
                              //    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI0vuP2m3JkbwjczFfZwIxqAy8Ub55p1lw7rtSiREp1A&s")
                              : ProductCard(producto: producto3, isPedido: 1)
                      //productName: "Quesillo",
                      //productPrice: 6.0,
                      //productImage:
                      //    "https://mmedia.estampas.com/18856/quesillo-sin-huequitos-81792.jpg")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer<CartController>(builder: (context, cartController, child) {
          if (cartController.pedido.productos.isNotEmpty) {
            final nroProductos =
                cartController.pedido.productos.values.reduce((a, b) => a + b);
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[50],
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
                                builder: (context) => detallePedido()
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
              ),
            );
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        })
      ]),
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
