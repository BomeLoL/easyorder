import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/screens/detalleProducto/layouts/product_bottom_navigation.dart';
import 'package:easyorder/views/screens/detalleProducto/layouts/product_comment.dart';
import 'package:easyorder/views/screens/detalleProducto/layouts/product_image.dart';
import 'package:easyorder/views/screens/detalleProducto/layouts/product_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/screens/detalleProducto/components/quantity_button.dart';

class detalleProducto extends StatefulWidget {
  const detalleProducto(
      {super.key,
      required this.info,
      required this.producto,
      this.isPedido = 1,
      this.comment = ''});
  final String info;
  final ItemMenu producto;
  final int isPedido;
  final String comment;

  @override
  State<detalleProducto> createState() => _detalleProductoState();
}

class _detalleProductoState extends State<detalleProducto> {
  late TextController textController;

  @override
  void initState() {
    super.initState();
    textController = Provider.of<TextController>(context, listen: false);
    if (widget.isPedido == 0) {
      if (widget.comment != null) {
        textController.getController('field1').text = widget.comment!;
      }
    }
  }

  @override
  void dispose() {
    textController
        .clearText('field1'); // Limpiar el texto del TextField asociado
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textController = Provider.of<TextController>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Text(
            'Detalles del producto',
            style: titleStyle,
          ),
        ),
        body: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  ProductImage(
                      imgUrl: widget
                          .producto.imgUrl), //muestra la imagen del producto
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
                                children: [
                                  ProductInfo(
                                      producto: widget
                                          .producto), // seccion de la info del producto
                                  ProductComment(
                                      controller:
                                          textController), // seccion que muestra la opcion de ponerle comentarios a un producto
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
        bottomNavigationBar: ProductBottomNavigation(
          producto: widget.producto,
          comment: widget.comment,
          isPedido: widget.isPedido,
          textController: textController,
        ));
  }
}
