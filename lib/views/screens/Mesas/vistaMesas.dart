import 'package:easyorder/controllers/restaurante_controller.dart';
import 'package:easyorder/models/clases/mesa.dart';
import 'package:easyorder/views/screens/Mesas/layouts/bottom_buttons_mesas.dart';
import 'package:easyorder/views/screens/Mesas/layouts/show_mesas.dart';
import 'package:easyorder/views/Widgets/navigationBar/navigationBarRestaurant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Vistamesas extends StatefulWidget {
  const Vistamesas({super.key, required this.mesa});

  final List<Mesa> mesa;
  @override
  State<Vistamesas> createState() => _VistamesasState();
}

class _VistamesasState extends State<Vistamesas> {
  bool error = false;
  late RestauranteController restauranteController;

  @override
  void initState() {
    super.initState();
    restauranteController =
        Provider.of<RestauranteController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) {
          return route.settings.name == 'menu';
        });

        return await true;
      },
      child: Consumer<RestauranteController>(
        builder: (context, restauranteController, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(0, 255, 255, 255),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text(
                "Mesas registradas",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                //
                ShowMesas(restauranteController: restauranteController, mesa: widget.mesa),
                //
                BottomButtonsMesas(restauranteController: restauranteController, mesa: widget.mesa)
              ],
            ),
            bottomNavigationBar: BarNavigationRestaurant(),
          );
        },
      ),
    );
  }
}
