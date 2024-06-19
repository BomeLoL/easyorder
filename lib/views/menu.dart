import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/edit_product_card.dart';
import 'package:easyorder/views/Widgets/menu_card.dart';
import 'package:easyorder/views/Widgets/navigationBar.dart';
import 'package:easyorder/views/detalleAdmin.dart';
import 'package:easyorder/views/detallePedido.dart';
import 'package:easyorder/views/edit_categories.dart';
import 'package:easyorder/views/vistaQr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MenuView extends StatefulWidget {
  const MenuView({
    super.key,
    required this.info,
    required this.restaurante,
    required this.idMesa,
    this.rol = 'admin',
  });

  final String info;
  final Restaurante restaurante;
  final int idMesa;
  final String rol;

  @override
  State<MenuView> createState() => _MenuState();
}

class _MenuState extends State<MenuView> {
  String nombreRes = "";
  Set<String> categorias = Set<String>();
  int selectedIndex = -1;
  String selectedCategoria = "Todo";
  Color colorBoton1 = primaryColor;
  bool confirmation = false;
  late CategoriesController categoriesController;
  late MenuEditController menuEditController;

  @override
  void initState() {
    super.initState();
    menuEditController = Provider.of<MenuEditController>(context, listen: false);
    categoriesController = Provider.of<CategoriesController>(context, listen: false);
    nombreRes = widget.restaurante.nombre;
    categorias.add("Todo");
    selectedCategoria = menuEditController.selectedCategoria;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
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
                      SizedBox(
                          height: kToolbarHeight +
                              MediaQuery.of(context).size.height * 0.03),
                      _buildHeader(),
                      Gap(15),
                      Container(
                          width: double.infinity,
                          height: 50,
                          child: _buildCategoriesSection()),
                      SizedBox(
                        height: 10,
                      ),
                      if (widget.rol == 'admin') _buildDivider(),
                      Expanded(child: _buildProductList()),
                      if (widget.rol == 'admin') _buildAdminAddProductButton()
                    ],
                  ),
                ),
              ),
              if (widget.rol == 'user') _buildCartSummary()
            ],
          ),
        ),
        bottomNavigationBar: BarNavigation(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        nombreRes,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (widget.rol == 'admin') {
      return Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              'Categorías',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          //crear categoria
          IconButton(
            onPressed: () {
              categoriesController.getCategoriasfromBD(context,menuEditController.menu!, 0);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return EditCategories(menu: menuEditController.menu!, tipo: 0,);
              //     },
              //   ),
              // );
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
          ),
          //editar categoria
          IconButton(
            onPressed: () {
              categoriesController.getCategoriasfromBD(context,menuEditController.menu!, 1);
              
            },
            style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          //eliminar categoria
          IconButton(
            onPressed: () {
              categoriesController.getCategoriasfromBD(context,menuEditController.menu!, 2);
            },
            style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Text(
        "Menú del Restaurante",
        style: GoogleFonts.poppins(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildCategoriesSection() {
    return Consumer2<MenuEditController, CategoriesController> (builder: (context, menuController, categoriesController, child){
      print("Building Consumer: ${menuController.menu?.itemsMenu.length} items");
      if (categoriesController.categories == null || categoriesController.categories!.isEmpty) {
        return Container(); // Muestra un indicador de carga mientras se obtienen las categorías
      }
      categorias.clear();
      categorias.add("Todo");
      for (var elemento in categoriesController.categories!) {
      categorias.add(elemento);
      }
      return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Row(
            children: categorias
                .map((elemento) {
                  Color color = elemento == menuEditController.selectedCategoria
                      ? Color(0xFFFF5F04)
                      : Colors.white;
                  Color color1 = elemento == menuEditController.selectedCategoria
                      ? Colors.white
                      : Colors.black;
                  return [
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            menuEditController.selectedCategoria = elemento;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: color1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size(45, 40),
                        ),
                        child: Text(elemento)),
                    SizedBox(
                      width: 10,
                    ),
                  ];
                })
                .expand((widgets) => widgets)
                .toList()),
      ],
      );
    });    
  }

  Widget _buildProductList(){

    return Consumer2<MenuEditController, CategoriesController>(builder: (context, menuController,categoriesController, child){
      return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.zero,
      itemCount: menuController.menu!.itemsMenu.length,
      itemBuilder: (context, index) {
        if (menuEditController.selectedCategoria == "Todo" ||
            menuController.menu!.itemsMenu[index].categoria ==
                menuEditController.selectedCategoria) {
          return Column(
            children: [
              widget.rol == 'admin'
                  ? EditProductCard(
                      producto:
                          menuController.menu!.itemsMenu[index],
                      info: nombreRes)
                  : MenuCard(
                      producto:
                          menuController.menu!.itemsMenu[index],
                      info: nombreRes),
              SizedBox(
                height: 10,
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
    });
    
  }

  Widget _buildDivider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: primaryColor.withOpacity(0.3),
          thickness: 2,
        ),
        Gap(10),
        Text(
          'Productos',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Gap(10),
      ],
    );
  }

  Widget _buildAdminAddProductButton() {
    return Column(
      children: [
        Gap(10),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return detalleAdmin(idRestaurante: widget.restaurante.id);
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Text(
              'Agregar un producto',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Gap(10),
      ],
    );
  }

  Widget _buildCartSummary() {
    return Consumer<CartController>(
      builder: (context, cartController, child) {
    if (cartController.pedido.productos.isNotEmpty) {
      final nroProductos = cartController.totalCantidad();
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
                    nroProductos.toString() +
                        ' producto(s) en el carrito',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => detallePedido(
                              info: nombreRes,
                              restaurante: widget.restaurante,
                              idMesa: widget.idMesa)),
                    );
                  },
                  child: Text(
                    'Ver mi pedido',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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
  },
  );
  }

  Widget _buildBotomNavigationBar(){
    return Consumer<CartController>(
          builder: (context, cartController, child) {
            return BottomNavigationBar(
              backgroundColor: Colors.white,
              fixedColor: Color.fromRGBO(142, 142, 142, 1),
              selectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.qr_code,
                    size: 45.0,
                    color: primaryColor,
                  ),
                  label: "Escanear",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 45.0,
                    color: primaryColor,
                  ),
                  label: "Terminar sesión",
                )
              ],
              onTap: (int clickedIndex) async {
                if (clickedIndex == 1) {
                  await _showConfirmationDialog(context);
                  if (confirmation == true) {
                    setState(() {
                      cartController.haPedido = false;
                    });
                    Navigator.pop(context);
                  }
                } else if (clickedIndex == 0 &&
                    cartController.haPedido == false) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BarcodeScannerWithOverlay();
                      },
                    ),
                  );
                } else if (clickedIndex == 0 &&
                    cartController.haPedido == true) {
                  showCustomPopup(
                      context: context,
                      title: 'Finalice su estadía para escanear',
                      content: Text(
                          'Para escanear otro código, primero debes terminar tu sesión actual. Por favor, finaliza tu estadía para continuar.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                          child: Text(
                            'Ok',
                            style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]);
                }
              },
            );
          },
        );
  }

  Future<void> _showConfirmationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            '¿Terminar su estadía?',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Al confirmar, un mesero vendrá a atenderle para procesar el pago y ya no podrá hacer más pedidos. ¿Desea continuar?',
            textAlign: TextAlign.justify,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      confirmation = false;
                    });
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      confirmation = true;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Text(
                    'Confirmar',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
