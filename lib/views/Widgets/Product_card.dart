import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ItemMenu producto;
  final String info;
  final int isPedido;

  ProductCard({
    required this.producto,
    required this.info,
    required this.isPedido,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  detalleProducto(info: info, producto: producto)),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 125,
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      producto.imgUrl,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        producto.nombreProducto,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        producto.descripcion,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                                  colors: [Colors.orange, Colors.red])
                              .createShader(bounds);
                        },
                        child: Text(
                          '\$ ${producto.precio.toString()}',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Consumer<CartController>(
                    builder: (context, cartController, child) {
                  final productoPedido =
                      cartController.pedido.productos[producto];
                  if (productoPedido != null) {
                    return Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  cartController.deleteProduct(
                                      producto, info, context, isPedido);
                                },
                                icon: Icon(Icons.remove),
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(255, 95, 4, 0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    )),
                                color: Color.fromRGBO(255, 95, 4, 1),
                                iconSize: 20,
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              productoPedido.cantidad.toString(),
                              style: GoogleFonts.poppins(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  cartController.addProduct(producto);
                                },
                                icon: Icon(Icons.add),
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(255, 95, 4, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    )),
                                color: Colors.white,
                                iconSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Flexible(
                      flex: 2,
                      child: Container(
                        child: IconButton(
                          onPressed: () {
                            cartController.addProduct(producto);
                          },
                          icon: Icon(Icons.add),
                          style: IconButton.styleFrom(
                              backgroundColor: Color.fromRGBO(255, 95, 4, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              )),
                          color: Colors.white,
                          iconSize: 20,
                        ),
                      ),
                    );
                  }
                })
              ],
            ),
          ),
          if (isPedido != 1)
            Consumer<CartController>(builder: (context, cartController, child) {
              return Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    child: IconButton(
                      onPressed: () {
                        showCustomPopup(
                            context: context,
                            title: '¿Eliminar todos?',
                            content: Text(
                                'Al seleccionar confirmar se eliminarán todos los productos del tipo "${producto.nombreProducto}" del carrito'),
                            actions: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7))),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancelar',
                                          style: GoogleFonts.poppins(
                                              color: const Color.fromRGBO(
                                                  255, 95, 4, 1),
                                              fontWeight: FontWeight.bold),
                                          textScaler: TextScaler.linear(0.9),
                                        )),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              255, 95, 4, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        cartController.deleteProducts(
                                            producto, info, context, isPedido);
                                      },
                                      child: Text(
                                        'Confirmar',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textScaler: TextScaler.linear(0.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 22,
                        color: Colors.red,
                      ),
                      style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                    ),
                  ));
            }),
        ],
      ),
    );
  }
}
