import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/product_card_base.dart';
import 'package:easyorder/views/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderCard extends ProductCardBase {
  final int isPedido = 0;

  OrderCard({
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detalleProducto(
          info: info,
          producto: producto,
          isPedido: isPedido,
          comment: comment,
        ),
      ),
    );
  }

  @override
  Widget buildQuantityController (BuildContext context){
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        final productoPedido = cartController.pedido
            .getProductIfExists(producto, comentario: comment);
          return _buildQuantityAdjuster(cartController, productoPedido!);
      },
    );
  }

  @override
  Widget buildDeleteButton(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        return Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            child: IconButton(
              onPressed: () => _showDeleteConfirmation(context, cartController),
              icon: Icon(Icons.close, size: 22, color: Colors.red),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
        );
      },
    );
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

  /// Metodo que elimina todos los ItemPedido asociados a una tarjeta
  void _showDeleteConfirmation(BuildContext context, CartController cartController) {
    showCustomPopup(
      context: context,
      title: '¿Eliminar todos?',
      content: Text('Al seleccionar confirmar se eliminarán todos los productos del tipo "${producto.nombreProducto}" del carrito'),
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
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaler: TextScaler.linear(0.9),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  var productoP = cartController.pedido
                      .getProductIfExists(producto, comentario: comment);
                  cartController.deleteProducts(
                    productoP, info, context,
                  );
                },
                child: Text(
                  'Confirmar',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaler: TextScaler.linear(0.9),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///Construye los botones de agregar y eliminar una unidad de producto
  Widget _buildQuantityAdjuster(CartController cartController, itemPedido productoPedido) {
    return Expanded(
      flex: 8,
      child: Row(
        children: [
          _buildRemoveButton(cartController),
          Spacer(flex: 1),
          _buildProductQuantityText(productoPedido),
          Spacer(flex: 1),
          _buildAddButton(cartController),
        ],
      ),
    );
  }
  /// Construye el boton de reducir producto en una unidad
  Widget _buildRemoveButton(CartController cartController) {
    return Expanded(
      flex: 4,
      child: Container(
        child: IconButton(
          onPressed: () => cartController.deleteProduct(
            producto, info,
            comentario: comment,
          ),
          icon: Icon(Icons.remove),
          style: IconButton.styleFrom(
            backgroundColor: Color.fromRGBO(255, 95, 4, 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          color: primaryColor,
          iconSize: 20,
        ),
      ),
    );
  }

  ///Muestra la cantidad actual de ese producto
  Widget _buildProductQuantityText(itemPedido productoPedido) {
    return Expanded(
      flex: 2,
      child: Text(
        productoPedido.cantidad.toString(),
        style: GoogleFonts.poppins(),
        textAlign: TextAlign.center,
      ),
    );
  }
  ///Muestra el botón de añadir una unidad de producto
  Widget _buildAddButton(CartController cartController) {
    return Flexible(
      flex: 4,
      child: Container(
        child: IconButton(
          onPressed: () => cartController.addProduct(producto, comentario: comment),
          icon: Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          color: Colors.white,
          iconSize: 20,
        ),
      ),
    );
  }  
}