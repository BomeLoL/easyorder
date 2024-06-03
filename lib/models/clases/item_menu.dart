
class ItemMenu {
  final int id; 
  final String nombreProducto;
  final String descripcion;
  final double precio;
  final String categoria;
  final String imgUrl;

  ItemMenu({
    required this.id, 
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
      other.id == id &&
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
      'id': id,
      'nombreProducto': nombreProducto,
      'descripcion': descripcion,
      'precio': precio,
      'categoria': categoria,
      'imgUrl': imgUrl,
    };
  }
    ItemMenu.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nombreProducto = map['nombreProducto'],
        descripcion = map['descripcion'],
        precio = map['precio'],
        categoria = map['categoria'],
        imgUrl = map['imgUrl'];
}
