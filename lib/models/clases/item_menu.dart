
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ItemMenu &&
      other.nombreProducto == nombreProducto &&
      other.precio == precio &&
      other.categoria == categoria &&
      other.imgUrl == imgUrl;
  }

  @override
  int get hashCode {
    return nombreProducto.hashCode ^
      precio.hashCode ^
      categoria.hashCode ^
      imgUrl.hashCode;
  }
}