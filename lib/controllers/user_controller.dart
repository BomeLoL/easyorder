import 'package:easyorder/models/clases/usuario.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
    Usuario? usuario = null;
  
    Usuario? get _usuario => usuario;

  set pedido(Usuario? nuevoUsuario) {
    usuario = nuevoUsuario;
    notifyListeners();
  }
}