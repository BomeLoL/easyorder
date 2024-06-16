import 'package:easyorder/controllers/cart_controller.dart';
import 'package:easyorder/models/clases/itemPedido.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/Card_customization.dart';
import 'package:easyorder/views/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ItemMenu producto;
  final String info;
  final int isPedido; /// Indica si la tarjeta está en el menú o en detalles del pedido
  final String comment;

  ProductCard({
    required this.producto,
    required this.info,
    required this.isPedido,
    this.comment = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetalleProducto(context),
      child: _buildCardContent(context),
    );
  }

  /// Navega a la ventana de detalles del producto
  void _navigateToDetalleProducto(BuildContext context) {
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

  /// Gestiona el condicional
  Widget _buildCardContent(BuildContext context) {
    return Stack(
      children: [
        _buildCardContainer(context),
        if (isPedido != 1) _buildDeleteButton(context),
      ],
    );
  }

  /// Construye el contenedor de la tarjeta
  Widget _buildCardContainer(BuildContext context) {
    return Container(
      height: 140,
      padding: EdgeInsets.all(13),
      decoration: _buildBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProductImage(),
          Spacer(flex: 1),
          _buildProductDetails(),
          Spacer(flex: 1),
          _buildQuantityController(context),
        ],
      ),
    );
  }

  /// Gestiona el color y la forma del contenedor
  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
    );
  }

  /// Construye la imagen del producto
  Widget _buildProductImage() {
    return Expanded(
      flex: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.network(
          producto.imgUrl,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Ensambla y muestra los detalles del producto
  Widget _buildProductDetails() {
    return Expanded(
      flex: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductName(),
          _buildProductDescription(),
          _buildProductPrice(),
        ],
      ),
    );
  }

  /// Muestra el nombre
  Widget _buildProductName() {
    return Text(
      producto.nombreProducto,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    );
  }

  /// Muestra la descripción
  Widget _buildProductDescription() {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      text: TextSpan(
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        children: _buildDescriptionTextSpans(),
      ),
    );
  }

  /// Si la tarjeta está en el menú muestra la descripción y si está en detalles del pedido muestra comentarios
  List<TextSpan> _buildDescriptionTextSpans() {
    if (isPedido == 0) {
      return comment.isEmpty
          ? [TextSpan(text: 'Sin comentarios')]
          : [
              TextSpan(
                text: 'Nota: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: comment),
            ];
    } else {
      return [
        TextSpan(
          text: producto.descripcion,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ];
    }
  }

  ///Muestra el precio del producto
  Widget _buildProductPrice() {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [Colors.orange, Colors.red],
        ).createShader(bounds);
      },
      child: Text(
        '\$${producto.precio}',
        style: GoogleFonts.poppins(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Gestiona los condicionales según la vista en que esté
  Widget _buildQuantityController(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        final productoPedido = cartController.pedido
            .getProductIfExists(producto, comentario: comment);

        if (productoPedido != null &&
            (!cartController.isCommented(productoPedido.producto.id) ||
                (cartController.getQuantityByProduct(productoPedido.producto.id) > 0 &&
                    isPedido == 0))) {
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

  /// Muestra el - cantidad + en cada tarjeta
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
            producto, info, isPedido,
            comentario: comment,
          ),
          icon: Icon(Icons.remove),
          style: IconButton.styleFrom(
            backgroundColor: Color.fromRGBO(255, 95, 4, 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          color: Color.fromRGBO(255, 95, 4, 1),
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
            backgroundColor: Color.fromRGBO(255, 95, 4, 1),
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
            backgroundColor: Color.fromRGBO(255, 95, 4, 1),
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
            ProductCard(
              producto: producto.producto,
              isPedido: 0,
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
                onPressed: () => _navigateToDetalleProducto(context),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 95, 4, 1),
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
  ///Construye un botón para borrar todos los productos de un tipo a la vez
  ///
  ///Muestra una popUp para confirmar la decisión del usuario
  Widget _buildDeleteButton(BuildContext context) {
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

  /// Construye la popUp de confirmación para eliminar todos los productos
  /// 
  /// Al presionar confirmar se busca el producto en el carrito y se 
  /// eliminan todos los de ese tipo
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
                    color: Color.fromRGBO(255, 95, 4, 1),
                    fontWeight: FontWeight.bold,
                  ),
                  textScaler: TextScaler.linear(0.9),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 95, 4, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  var productoP = cartController.pedido
                      .getProductIfExists(producto, comentario: comment);
                  cartController.deleteProducts(
                    productoP, info, context, isPedido,
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
}
