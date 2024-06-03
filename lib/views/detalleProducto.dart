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

class detalleProducto extends StatefulWidget {
  const detalleProducto(
      {super.key, required this.info, required this.producto});
  final String info;
  final ItemMenu producto;

  @override
  State<detalleProducto> createState() => _detalleProductoState();
}

class _detalleProductoState extends State<detalleProducto> {
  bool isCarrito = true;
  late int cantidad;

  @override
  void initState() {
    super.initState();
    cantidad = context.read<CartController>().getOneProductQuantity(widget.producto);
    if(cantidad == 0){
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
    if ((isCarrito == true && cantidad > 0) || (isCarrito == false && cantidad > 1)) {
      setState(() {
        cantidad--;
      });
    }
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
                  child: Image.network(
                    widget.producto.imgUrl,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
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
                                  widget.producto.nombreProducto,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                SizedBox(height: 25),

                                Text(
                                  '\$${widget.producto.precio}',
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                              SizedBox(height: 25),

                                Text(
                                  'In a medium bowl, add ground chicken, breadcrumbs, mayonnaise, onions, parsley, garlic, paprika, salt and pepper. Use your hands to combine all the ingredients together until blended, but don\'t over mix.',
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),

                                // Text(
                                //   'Comentarios adicionales',
                                //   style: GoogleFonts.poppins(
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //   ),
                                // ),

                                // Text(
                                //   text:
                                //       'Hazle saber al restaurante los detalles a tener en cuenta al preparar tu pedido.',
                                //   style: GoogleFonts.poppins(
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.normal,
                                //     color: Colors.black38,
                                //   ),
                                // ),

                                // TextField(
                                //   decoration: InputDecoration(
                                //       border: OutlineInputBorder(),
                                //       hintText: '(Opcional)',
                                //       hintStyle: const TextStyle(
                                //           fontSize: 14.0,
                                //           color: Colors.black38)),
                                // ),
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
                flex: 6,
                child: QuantityButton(
                      agregar: agregar,
                      eliminar: eliminar,
                      cantidad: cantidad,
                    )
              ),
              Spacer(
                flex: 1,
              ),
              Consumer<CartController>(
                  builder: (context, cartController, child) {
                return Expanded(
                  flex: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      cartController.updateProductQuantity(widget.producto, cantidad);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 95, 4, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        String textOfbutton = 'Agregar';
                        if(isCarrito == true){
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
                      }
                    ),
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
