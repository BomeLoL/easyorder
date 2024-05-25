import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class detallePedido extends StatefulWidget {
  const detallePedido({super.key});

  @override
  State<detallePedido> createState() => _detallePedidoState();
}

class _detallePedidoState extends State<detallePedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        ),
        body: Stack(
          children: [
            Positioned(
              top: -100,
              right: 0,
              child: Transform.rotate(
                angle: -0.7,
                child: Image.asset(
                  'images/background.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  ),
                ),
            ),
            Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles del pedido',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(25),
                Container(
                  width: double.infinity,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ProductCard(
                        productName: 'Hamburguesa',
                        productPrice: 19.8,
                        productImage:
                            'https://recetasdeusa.com/wp-content/uploads/2022/05/Hamburguesa-americana-1-scaled.jpg',
                      ),
                      Gap(20),
                      ProductCard(
                        productName: 'Hamburguesa',
                        productPrice: 19.8,
                        productImage:
                            'https://recetasdeusa.com/wp-content/uploads/2022/05/Hamburguesa-americana-1-scaled.jpg',
                      ),
                      Gap(20),
                      ProductCard(
                        productName: 'Hamburguesa',
                        productPrice: 19.8,
                        productImage:
                            'https://recetasdeusa.com/wp-content/uploads/2022/05/Hamburguesa-americana-1-scaled.jpg',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ]
        ));
  }
}
