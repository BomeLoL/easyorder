import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ItemMenu producto;
  final int cantidad;

  ProductCard({
    required this.producto,
    required this.cantidad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Column(
            children: [
              Text(
                producto.nombreProducto,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Text(
                'descripcion',
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
          Consumer<CartController>(
            builder: (context, cartController, child){
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
              Text(
                cantidad.toString(),
                style: GoogleFonts.poppins(),
                ), //implementar funcionalidad
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
            })
        ],
      ),
    );
  }
}
