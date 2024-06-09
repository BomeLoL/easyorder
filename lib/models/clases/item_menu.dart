
class ItemMenu {
  final int id;
  final String nombreProducto;
  final String descripcion;
  final double precio;
  final String categoria;
  final String imgUrl;
  List<Map<String, dynamic>> extras;

  ItemMenu({
    required this.id,
    required this.nombreProducto,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.imgUrl,
    required this.extras,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemMenu &&
        other.id == id &&
        other.nombreProducto == nombreProducto &&
        other.precio == precio &&
        other.categoria == categoria &&
        other.imgUrl == imgUrl &&
        other.extras == extras;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombreProducto.hashCode ^
        descripcion.hashCode ^
        precio.hashCode ^
        categoria.hashCode ^
        imgUrl.hashCode ^
        extras.hashCode
        ;
  }

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'nombreProducto': nombreProducto,
    'descripcion': descripcion,
    'precio': precio,
    'categoria': categoria,
    'imgUrl': imgUrl,
    'extras': extras.map((extra) => Map<String, dynamic>.from(extra)).toList(),
  };
}

ItemMenu.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      nombreProducto = map['nombreProducto'],
      descripcion = map['descripcion'],
      precio = map['precio'],
      categoria = map['categoria'],
      imgUrl = map['imgUrl'],
      extras = (map['extras'] as List).map((extra) => Map<String, dynamic>.from(extra)).toList();
}