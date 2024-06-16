class Usuario{
  final String nombre; 
  final String usertype;
  final double saldo;
  final String cuenta;

  Usuario({
    required this.nombre, required this.usertype, required this.saldo,required this.cuenta, 
  });

  Map<String, dynamic> toJson()=>{
  'nombre':nombre,
  'usertype':usertype,
  'saldo':saldo,
  'cuenta':cuenta,
};

  static Usuario fromJson(Map<String,dynamic> json) => Usuario(nombre: json['nombre'], usertype: json['usertype'], saldo: json['saldo'], cuenta: json['cuenta']);

}