class Usuario {
   String nombre;
   String usertype;
   double saldo;
   String cuenta;
   String correo;

  Usuario({
    required this.nombre,
    required this.usertype,
    required this.saldo,
    required this.cuenta,
    required this.correo,
  });



  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'usertype': usertype,
        'saldo': saldo,
        'cuenta': cuenta,
        'correo': correo,
      };

  static Usuario fromJson(Map<String, dynamic> json) => Usuario(
        nombre: json['nombre'] ,
        usertype: json['usertype'],
        saldo: json['saldo']is double
        ? json['saldo']
        : double.parse(json['saldo'].toString()),
        cuenta: json['cuenta'],
        correo: json['correo'],
      );
}
