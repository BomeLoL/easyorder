
class ItemMenu {
  final String nombreProducto;
  final double precio;
  final String categoria;
  final String imgUrl;

  ItemMenu({
    required this.nombreProducto,
    required this.precio,
    required this.categoria,
    required this.imgUrl,
  });

    Map<String, dynamic> toMap() {
    return {
      'nombreProducto': nombreProducto,
      'precio': precio,
      'categoria': categoria,
      'imgUrl': imgUrl,
    };
  }
}