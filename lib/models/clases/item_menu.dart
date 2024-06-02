
class ItemMenu {
  final String nombreProducto;
  final String descripcion;
  final double precio;
  final String categoria;
  final String imgUrl;

  ItemMenu({
    required this.nombreProducto,
    required this.descripcion,
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

    Map<String, dynamic> toMap() {
    return {
      'nombreProducto': nombreProducto,
      'descripcion': descripcion,
      'precio': precio,
      'categoria': categoria,
      'imgUrl': imgUrl,
    };
  }
    ItemMenu.fromMap(Map<String, dynamic> map)
      : nombreProducto = map['nombreProducto'],
        descripcion = map['descripcion'],
        precio = map['precio'],
        categoria = map['categoria'],
        imgUrl = map['imgUrl'];
}
