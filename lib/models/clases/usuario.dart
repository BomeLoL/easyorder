class Usuario {
  String id; // Nuevo campo
  String nombre;
  String usertype;
  double saldo;
  String cuenta;
  String correo;

  Usuario({
    required this.id, // Agregar id al constructor
    required this.nombre,
    required this.usertype,
    required this.saldo,
    required this.cuenta,
    required this.correo,
  });

  Map<String, dynamic> toJson() => {
        'id': id, // Incluir id en el JSON
        'nombre': nombre,
        'usertype': usertype,
        'saldo': saldo,
        'cuenta': cuenta,
        'correo': correo,
      };

  static Usuario fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'], // Manejar id en el JSON
        nombre: json['nombre'],
        usertype: json['usertype'],
        saldo: json['saldo'] is double
            ? json['saldo']
            : double.parse(json['saldo'].toString()),
        cuenta: json['cuenta'],
        correo: json['correo'],
      );
}
