import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_popup.dart';
import 'package:easyorder/views/Widgets/productCard/product_card_base.dart';
import 'package:easyorder/views/detalleAdmin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProductCard extends ProductCardBase {
  final String idRestaurante;
  EditProductCard({
    required ItemMenu producto,
    required String info,
    required this.idRestaurante,
  }) : super(
          producto: producto,
          info: info,
        );

  @override
  Widget buildQuantityController(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: IconButton(
                onPressed: () async {
                                      Provider.of<SpinnerController>(context, listen: false).setLoading(false);

                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                  navigateToDetalleProducto(context);}
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
              )),
          Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 4,
              child: IconButton(
                onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                  _showDialog(context, producto);}
                },
                icon: Icon(
                  Icons.delete,
                  color: primaryColor,
                ),
              ))
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, ItemMenu producto) {
    showCustomPopup(
      context: context,
      title: '¿Eliminar "${producto.nombreProducto}"?',
      content: Text(
        'Si seleccionas confirmar se eliminará el producto "${producto.nombreProducto}" del menú.',
      ),
      actions: [
        Consumer<SpinnerController>(
            builder: (context, spinnerController, child) {
          if (spinnerController.isLoading == true) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else {
            return Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: TextScaler.linear(0.9),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onPressed: () async {

                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                      spinnerController.setLoading(true);
                      try {
                        await Provider.of<MenuEditController>(
                          context,
                          listen: false,
                        ).deleteProduct(idRestaurante, producto);
                        // Si la eliminación fue exitosa, cerrar el diálogo
                        Navigator.of(context).pop();
                      } catch (e) {
                        // Manejo de errores si es necesario
                        print('Error al eliminar el producto: $e');
                      } finally {
                        spinnerController.setLoading(false);
                      }
                    }},
                    child: Text(
                      'Confirmar',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: TextScaler.linear(0.9),
                    ),
                  ),
                ),
              ],
            );
          }
        })
      ],
    );
  }

  @override
  Widget buildDeleteButton(BuildContext context) {
    return Container();
  }

  @override
  void navigateToDetalleProducto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detalleAdmin(
          producto: producto,
          idRestaurante: idRestaurante,
        ),
      ),
    );
  }
}
