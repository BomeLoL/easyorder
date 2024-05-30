import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ItemMenu producto;
  final int isPedido;

  ProductCard({
    required this.producto,
    required this.isPedido,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(
              producto.imgUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  producto.nombreProducto,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'daaaaaaa aaaaaaaaaa ddd',
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
                        colors: [Colors.orange, Colors.red]).createShader(bounds);
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
          Consumer<CartController>(
            builder: (context, cartController, child){
              final cantidad = cartController.pedido.productos[producto];
            if (cantidad != null){
              return Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove),
                        style: IconButton.styleFrom(
                            backgroundColor: Color.fromRGBO(255, 95, 4, 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            )),
                        color: Color.fromRGBO(255, 95, 4, 1),
                        iconSize: 20,
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      width: 20,
                      child: Text(
                        cantidad.toString(),
                        style: GoogleFonts.poppins(),
                        textAlign: TextAlign.center,
                        ),
                    ),
                    const Gap(10),
                    Container(
                      width: 35,
                      height: 35,
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
                  ],
              );
              }else {
                return Container(
                        width: 35,
                        height: 35,
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
                      );
              } 
            })
        ],
      ),
    );
  }
}
