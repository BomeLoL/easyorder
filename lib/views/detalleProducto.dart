import 'package:easyorder/models/clases/restaurante.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/views/menu.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/escaneoQR.dart';
import 'package:easyorder/views/Widgets/quantity_button.dart';

class detalleProducto extends StatefulWidget {
  const detalleProducto({super.key, required this.info, required this.producto});
  final String info;
  final ItemMenu producto;

  @override
  State<detalleProducto> createState() => _detalleProductoState();
}

class textContainer extends StatelessWidget {
  const textContainer({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.color,
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.5),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          fontSize: size,
          fontWeight: weight,
          color: color,
        ),
      ),
    );
  }
}


class _detalleProductoState extends State<detalleProducto> {
  int cantidad = 1;

  void agregar() {
    setState(() {
      cantidad++;
    });
  }

  void eliminar() {
    if (cantidad > 1) {
      setState(() {
        cantidad--;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              collapsedHeight: 56,
              expandedHeight: 350,
              floating: false,
              pinned: true,
              scrolledUnderElevation: 0,
              backgroundColor: innerBoxIsScrolled
                  ? Colors.white
                  : Color.fromARGB(0, 255, 255, 255),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        widget.producto.imgUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ClipRRect(
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(children: [
                      //Icon(icon);
                      textContainer(
                          text: widget.producto.nombreProducto,
                          size: 25,
                          weight: FontWeight.normal,
                          color: Colors.black),

                      textContainer(
                          text: '${widget.producto.precio}\$',
                          size: 18,
                          weight: FontWeight.bold,
                          color: Colors.black),

                      textContainer(
                          text:
                              'In a medium bowl, add ground chicken, breadcrumbs, mayonnaise, onions, parsley, garlic, paprika, salt and pepper. Use your hands to combine all the ingredients together until blended, but don\'t over mix.',
                          size: 14,
                          weight: FontWeight.normal,
                          color: Colors.black),

                      textContainer(
                          text: 'Comentarios adicionales',
                          size: 18,
                          weight: FontWeight.bold,
                          color: Colors.black),

                      textContainer(
                          text:
                              'Hazle saber al restaurante los detalles a tener en cuenta al preparar tu pedido.',
                          size: 14,
                          weight: FontWeight.normal,
                          color: Colors.black38),

                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '(Opcional)',
                            hintStyle: const TextStyle(
                                fontSize: 14.0, color: Colors.black38)),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Positioned(
        //  top: 20,
        //  left: 20,
        //  child: IconButton(
        //    icon: Icon(Icons.arrow_back),
        //    onPressed: () {
        //      // Handle button press
        //    },
        //    style: IconButton.styleFrom(
        //      backgroundColor: Color.fromRGBO(255, 96, 4, 0.2),
        //      shape: RoundedRectangleBorder(
        //        borderRadius: BorderRadius.circular(7),
        //      ),
        //    ),
        //  ),
        //),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 6,
              child: QuantityButton(
                agregar: agregar,
                eliminar: eliminar,
                cantidad: cantidad,
              ),
            ),
           Spacer(flex: 1,),
            Consumer<CartController>(builder: (context, cartController, child) {
              return Expanded(
                flex: 10,
                child: TextButton(
                  onPressed: () {
                    cartController.addProducts(
                        widget.producto,
                        cantidad);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Menu(info: widget.info);
                    }));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 95, 4, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),

                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0), // Ajusta el padding vertical
                    child: Text(
                      "Agregar",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }), // Agrega un espacio de 12.5 entre los botones
            SizedBox(width: 12.5),
          ],
        ),
      ),
    );
  }
}
