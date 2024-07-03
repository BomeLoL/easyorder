import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/authService.dart';
import 'package:easyorder/views/screens/Wallet/Layouts/recargarView.dart';
import 'package:easyorder/views/screens/Wallet/Layouts/saldoView.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/navigationBar/navigationBarClientLogged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class walletView extends StatefulWidget {
  const walletView({super.key,
       this.info,
       this.restaurante,
       this.idMesa});
      
  final String? info;
  final Restaurante? restaurante;
  final int? idMesa;
  
  @override
  State<walletView> createState() => _walletViewState();
}

class _walletViewState extends State<walletView> {
  final myController = TextEditingController();
  double saldo = 0;
  bool vacio=false;
  final _auth = Authservice();
  
  void updateSaldo(double newSaldo) {
      setState(() {
        saldo = newSaldo;
      });
    }

  @override
  Widget build(BuildContext context) {
    UserController userController = Provider.of<UserController>(context, listen: false);
    if (userController.usuario?.saldo != null && userController.usuario!.saldo is double) {
      saldo = userController.usuario!.saldo!;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Background_image(
            child: Column(
              children: [
                //
                Saldoview(saldo: saldo.toString()),
                Recargarview(controller: myController, saldo: saldo, userController: userController, auth: _auth, onSaldoChanged: updateSaldo),
                //
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.idMesa != null && widget.restaurante != null && widget.info != null
          ? BarNavigationClientLogged(idMesa: widget.idMesa!, info: widget.info!, restaurante: widget.restaurante!)
          : null,
    );
}
}