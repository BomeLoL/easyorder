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
  List item_menu=[
    ItemMenu(
      nombreProducto: 'Parrilla con platano',
      precio: 15.1,
      categoria: "Parrilla Guanteña",
      imgUrl:
          'https://img.freepik.com/fotos-premium/plato-carnes-variadas-parrilla-gajos-patata-salsas_157927-2464.jpg'),
    ItemMenu(
      nombreProducto: 'Parrilla sin platano',
      precio: 14.0,
      categoria: "Parrilla Caraqueña",
      imgUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI0vuP2m3JkbwjczFfZwIxqAy8Ub55p1lw7rtSiREp1A&s'),
    ItemMenu(
      nombreProducto: 'Quesillo',
      categoria: "Postre",
      precio: 6.0,
      imgUrl:
          'https://mmedia.estampas.com/18856/quesillo-sin-huequitos-81792.jpg'),
    ItemMenu(
      nombreProducto: 'Helado',
      categoria: "Postre",
      precio: 1.0,
      imgUrl:
          'https://mmedia.estampas.com/18856/quesillo-sin-huequitos-81792.jpg'),
      
  ];
  Set <String> categorias= Set <String>();
  int selectedIndex = -1;
  String selectedCategoria = "";
  // List<int> botones = [0, 1, 2]; //se deberia tener un numero por cada categoria
  Color colorBoton1 = Color(0xFFFF5F04);
  //Color colorBoton2=Colors.white;

  @override
  void initState() {
    super.initState();
    infoQr = widget.info;
    item_menu.forEach((elemento) {
    categorias.add(elemento.categoria); // Agregar la categoría al conjunto
    });
    selectedCategoria = item_menu[0].categoria;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(infoQr, //tecnicamente infoQr tendra info que debera separarse, en esta parte iria el nombre del restaurante
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
                      padding: EdgeInsets.zero,
                      itemCount: item_menu.length,
                      itemBuilder: (context, index) {
                        String categoria = item_menu[index].categoria;
                        if (categoria == selectedCategoria) {
                          return Column(
                            children: [
                              ProductCard(producto: item_menu[index], isPedido: 1, info: infoQr,),
                              // ProductCardInit(
                              //   productName: item_menu[index]["Nombre"], 
                              //   productPrice: item_menu[index]["Precio"], 
                              //   productImage: "https://mmedia.estampas.com/18856/quesillo-sin-huequitos-81792.jpg"),
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
                                    builder: (context) => detallePedido(info:infoQr)
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