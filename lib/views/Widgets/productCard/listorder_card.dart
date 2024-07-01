import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/productCard/product_card_base.dart';
import 'package:easyorder/views/screens/detalleProducto/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListorderCard extends ProductCardBase {
  final int isPedido = 0;

  ListorderCard({
    required ItemMenu producto,
    required String info,
    required String comment,
  }) : super(
         producto: producto,
         info: info,
         comment: comment,
       );
  
  @override
  void navigateToDetalleProducto(BuildContext context) {
  }

  @override
  Widget buildCardOptions (BuildContext context){
    return Consumer<CheckController>(
      builder: (context, checkController, child) {
        final productoPedido = checkController.pedido
            .getProductIfExists(producto, comentario: comment);
          return _buildQuantityAdjuster(checkController, productoPedido!);
      },
    );
  }

  @override
  Widget buildDeleteButton(BuildContext context) {
    return Container();
  }

  ///Las tarjetas del pedido muestran el comentario asociado al itemPedido
  @override
  List<TextSpan> buildDescriptionTextSpans(){
    return comment.isEmpty
          ? [TextSpan(text: 'Sin comentarios')]
          : [
              TextSpan(
                text: 'Nota: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: comment),
            ];
  }


  ///Construye los botones de agregar y eliminar una unidad de producto
  Widget _buildQuantityAdjuster(CheckController checkController, itemPedido productoPedido) {
    return Expanded(
      flex: 5,
      child: Row(
        children: [
          Spacer(flex: 1),
          _buildProductQuantityText(productoPedido),
          Spacer(flex: 1),
        ],
      ),
    );
  }

  ///Muestra la cantidad actual de ese producto
  Widget _buildProductQuantityText(itemPedido productoPedido) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(7)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            productoPedido.cantidad.toString(),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

}