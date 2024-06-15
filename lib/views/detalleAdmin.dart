import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/cart_controller.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/Widgets/quantity_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class detalleAdmin extends StatefulWidget {
  const detalleAdmin({super.key, required this.info, required this.producto});
  final String info;
  final ItemMenu producto;

  @override
  State<detalleAdmin> createState() => _detalleAdminState();
}

class _detalleAdminState extends State<detalleAdmin> {
  bool isCarrito = true;
  late int cantidad;

  @override
  void initState() {
    super.initState();
    cantidad =
        context.read<CartController>().getOneProductQuantity(widget.producto);
    if (cantidad == 0) {
      cantidad = 1;
      isCarrito = false;
    }
  }

  void agregar() {
    setState(() {
      cantidad++;
    });
  }

  void eliminar() {
    if ((isCarrito == true && cantidad > 0) ||
        (isCarrito == false && cantidad > 1)) {
      setState(() {
        cantidad--;
      });
    }
  }

  File? _image;
  Future _getImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Detalles del producto',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: (){_getImage;},
                    child: Container(
                      
                      child: Image.network(
                        widget.producto.imgUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(35),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                //Icon(icon);
                                Text(
                                  'Nombre del producto *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(255, 95, 4, 1)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(125, 45, 0, 1)),
                                      ),
                                      hintText: 'Ej. Hamburguesa Clásica',
                                      hintStyle: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black38)),
                                ),

                                SizedBox(height: 25),

                                Text(
                                  'Precio *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(255, 95, 4, 1)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(125, 45, 0, 1)),
                                      ),
                                      hintText: 'Ej. 12',
                                      hintStyle: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black38)),
                                ),

                                SizedBox(height: 25),

                                Text(
                                  'Descripción *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                TextField(
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(255, 95, 4, 1)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(125, 45, 0, 1)),
                                      ),
                                      hintText:
                                          'Ej. Pan brioche, 200g de carne, lechuga, tomate, queso amarillo...',
                                      hintStyle: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black38)),
                                ),

                                SizedBox(height: 25),
                                Text(
                                  'Categoría *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                DropdownButtonHideUnderline(
                                  child: Container(
                                    width: double
                                        .infinity, // This makes the dropdown width fit the screen
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromRGBO(255, 95, 4,
                                              1)), // Set the border color
                                      borderRadius: BorderRadius.circular(
                                          4.0), // Optional: Add border radius
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.5),
                                      child: DropdownButton<String>(
                                        isExpanded:
                                            true, // This makes the dropdown width fit the screen
                                        items: [
                                          DropdownMenuItem(
                                            value: 'item1',
                                            child: Text('Elemento 1'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'item2',
                                            child: Text('Elemento 2'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'item3',
                                            child: Text('Elemento 3'),
                                          ),
                                        ], // Add your dropdown items here
                                        hint: Text('Seleccionar categoría',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors
                                                    .black38)), // Set the hint text
                                        onChanged: (String? value) {
                                          // Add your onChanged logic here
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 25),
                                Text(
                                  'Descuento %',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(255, 95, 4, 1)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(125, 45, 0, 1)),
                                      ),
                                      hintText: 'Ej. 50',
                                      hintStyle: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black38)),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          childCount: 1,
        ))
      ]),
      bottomNavigationBar: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 10,
                child: ElevatedButton(
                  onPressed: () {
                    _getImage;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .white, // Establece el color de fondo del botón a blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: BorderSide(
                          color: Color.fromRGBO(
                              255, 95, 4, 1)), // Establece el color del borde
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 95, 4,
                          1), // Establece el color del texto igual al color del borde
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Consumer<CartController>(
                  builder: (context, cartController, child) {
                return Expanded(
                  flex: 10,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 95, 4, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Builder(builder: (context) {
                      String textOfbutton = 'Agregar';
                      if (isCarrito == true) {
                        textOfbutton = 'Modificar';
                      }
                      return Text(
                        textOfbutton,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                );
              }), // Agrega un espacio de 12.5 entre los botones
              SizedBox(width: 12.5),
            ],
          ),
        ),
      ),
    );
  }
}
