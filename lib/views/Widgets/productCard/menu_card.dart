import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/productCard/order_card.dart';
import 'package:easyorder/views/Widgets/productCard/product_card_base.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuCard extends ProductCardBase {

  MenuCard({
    required ItemMenu producto,
    required String info,
    String comment = '',
  }) : super(
         producto: producto,
         info: info,
         comment: comment,
       );

  @override
  Widget buildCardOptions(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        final productoPedido = cartController.pedido
            .getProductIfExists(producto, comentario: comment);

        if (productoPedido != null &&
            (!cartController.isCommented(productoPedido.producto.id))) {
          return _buildQuantityAdjuster(cartController, productoPedido);
        } else if (cartController.getQuantityByProduct(producto.id) > 0 &&
            cartController.isCommented(producto.id)) {
          return _buildViewCustomizationButton(context, cartController);
        } else {
          return _buildAddButton(cartController);
        }
      },
    );
  }

  @override
  Widget buildDeleteButton(BuildContext context) {
    return Container();
  }


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

  /// Muestra un botón con la cantidad total de los productos del mismo tipo en el carrito
  /// Esto es en caso de que hayan productos con diferentes comentarios
  Widget _buildViewCustomizationButton(BuildContext context, CartController cartController) {
    return Flexible(
      flex: 2,
      child: Container(
        child: ElevatedButton(
          onPressed: () => _showCustomizationModal(context, cartController),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: Text(
            cartController.getQuantityByProduct(producto.id).toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///Muestra la ventana emergente inferior
  void _showCustomizationModal(BuildContext context, CartController cartController) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<CartController>(
          builder: (context, cartController, child) {
            if (cartController.getQuantityByProduct(producto.id) == 0) {
              Navigator.pop(context);
            }
            return SizedBox(
              height: 600,
              width: double.infinity,
              child: _buildCustomizationModalContent(context, cartController),
            );
          },
        );
      },
    );
  }

  ///Construye el contenido de la ventana emergente
  Widget _buildCustomizationModalContent(BuildContext context, CartController cartController) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.5),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Tus personalizaciones',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Expanded(
              flex: 25,
              child: _buildCustomizationList(cartController),
            ),
            _buildAddCustomizationButton(context),
          ],
        ),
      ),
    );
  }

  /// Construye una lista de personalizaciones para el producto actual.
  ///
  /// Filtra los productos en el carrito para mostrar solo aquellos que coinciden
  /// con el ID del producto actual. Luego, construye una lista de widgets que 
  /// representan cada personalización del producto.
  ///
  /// [cartController] es el controlador del carrito que proporciona el estado del carrito.
  Widget _buildCustomizationList(CartController cartController) {
    final productos = cartController.pedido.productos
        .where((producto) => producto.producto.id == this.producto.id)
        .toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        return Column(
          children: [
            OrderCard(
              producto: producto.producto,
              info: info,
              comment: producto.comentario!,
            ),
            SizedBox(height: 5),
          ],
        );
      },  
    );
  }

  /// Construye un botón para añadir nuevas personalizaciones
  /// 
  /// Al presionar el botón te lleva a la ventana de detalles
  /// del producto para que agreges la nueva personalizacion
  /// 
  Widget _buildAddCustomizationButton(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Expanded(
        flex: 3,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => this.navigateToDetalleProducto(context),
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(
                  "Agregar nueva",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}