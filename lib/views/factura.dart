import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/models/clases/pedido.dart';
import 'package:easyorder/models/clases/restaurante.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/Product_card.dart';
import 'package:easyorder/views/Widgets/background_image.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/views/pantallaCarga.dart';

class Factura extends StatefulWidget {
  const Factura(
      {super.key,
      required this.info,
      required this.menu,
      required this.restaurante, required this.idMesa});
      
  final String info;
  final Restaurante restaurante;
  final Menu menu;
  final int idMesa;

  @override
  State<Factura> createState() => _detalleFacturaState();
}

class _detalleFacturaState extends State<Factura> {
  
  bool funciona = false;
  bool confirmation = false;
  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        scrolledUnderElevation: 0,
      ),
      body: Consumer<CheckController>(
        builder: (context, checkcontroller, child) {
          if (checkcontroller.totalCantidad() == 0 && shouldPop == true){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) {
                return route.settings.name == 'menu';
              });
            });
            return SizedBox();
          } else {
            return Background_image(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: kToolbarHeight +
                          MediaQuery.of(context).size.height * 0.03),
                  Text(
                    'Mis Pedidos',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 25,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: checkcontroller.pedido.productos.length,
                      itemBuilder: (context, index) {
                        final producto = checkcontroller.pedido.productos[index];        
                        return Column(
                          children: [
                            ProductCard(
                              producto: producto.producto,
                              isPedido: 3,
                              info: widget.info,
                              comment: producto.comentario!,
                            ),
                            const Gap(20),
                          ],
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 150, // Cambiar a 180 con Sub-total y Descuentos
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 95, 4, 1),
                            Colors.red,
                          ],
                        )),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${checkcontroller.getTotalAmount()}',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                       
                        Expanded(
                          flex: 1, //Cambiar a 3 cuando se agrege nuevamente el Sub-total y Descuento
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                              CartController cartController = Provider.of<CartController>(context, listen: false);
                              final tester = await MongoDatabase.Test();
                              if (tester == false){
                              // ignore: use_build_context_synchronously
                              dbErrorDialog(context);
                              }
                              else{
                                await _showConfirmationDialog(context);
                                if (confirmation == true) {
                                    await MongoDatabase.vaciarPedidosDeMesa(widget.restaurante.id, widget.idMesa);
                                    cartController.haPedido = false;
                                    Navigator.of(context).popUntil((route) {
                                      return route.settings.name == 'menu';
                                    });
                                  }                                   
                              }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: Text(
                                'Pedir Cuenta',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 95, 4, 1),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
          }
          
        },
      ),
    );
  }

  //Esta función muestra el mensaje de error de cuando la orden falla
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Error',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            'Hubo un error inesperado procesando tu orden, por favor, inténtelo de nuevo',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  'Ok',
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(255, 96, 4, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


Future<void> _showConfirmationDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          '¿Terminar su estadía?',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Al confirmar, un mesero vendrá a atenderle para procesar el pago. ¿Desea continuar?',
          textAlign: TextAlign.justify,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    confirmation = false;
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.poppins(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    confirmation = true;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                child: Text(
                  'Confirmar',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}


}