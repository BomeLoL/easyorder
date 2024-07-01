import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/views/screens/detalleProducto/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ProductCardBase extends StatelessWidget {
  final ItemMenu producto;
  final String info;
  final String comment;

  ProductCardBase({
    required this.producto,
    required this.info,
    this.comment = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToDetalleProducto(context),
      child: _buildCardContent(context),
    );
  }

  /// Navega a la ventana de detalles del producto
  void navigateToDetalleProducto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detalleProducto(
          info: info,
          producto: producto,
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
        buildDeleteButton(context), //solo si es la tarjeta del pedido
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
          buildCardOptions(context),
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
        children: buildDescriptionTextSpans(),
      ),
    );
  }

  List<TextSpan> buildDescriptionTextSpans(){
    return [
        TextSpan(
          text: producto.descripcion,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ];
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

  Widget buildCardOptions(BuildContext context);
  Widget buildDeleteButton(BuildContext context);

}