import 'package:easyorder/controllers/pedido_controller.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductBottomNavigation extends StatefulWidget {
  final ItemMenu producto;
  final String comment;
  final int isPedido;
  final TextController textController;
  const ProductBottomNavigation({required this.producto, required this.comment, required this.isPedido, required this.textController});

  @override
  State<ProductBottomNavigation> createState() => _ProductBottomNavigationState();
}

class _ProductBottomNavigationState extends State<ProductBottomNavigation> {

late int cantidad;

void initState() {
    super.initState();
    if (widget.isPedido == 0) {
      cantidad = context
          .read<CartController>()
          .getOneProductQuantity(widget.producto, comentario: widget.comment);
    } else {
      cantidad = 1;
    }
  }

  void agregar() {
    setState(() {
      cantidad++;
    });
  }

  void eliminar() {
    if ((widget.isPedido == 0 && cantidad > 0) ||
        (widget.isPedido == 1 && cantidad > 1)) {
      setState(() {
        cantidad--;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[50],
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 6,
                  child: QuantityButton(
                    agregar: agregar,
                    eliminar: eliminar,
                    cantidad: cantidad,
                  )),
              Spacer(
                flex: 1,
              ),
              Consumer<CartController>(
                  builder: (context, cartController, child) {
                return Expanded(
                  flex: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      String field1Text = widget.textController.getText('field1');
                      if (widget.isPedido == 1) {
                        cartController.addProducts(widget.producto, cantidad,
                            comentario: field1Text);
                      } else {
                        cartController.updateProductQuantity(
                            widget.producto, cantidad,
                            comentario: widget.comment);
                        if (widget.comment != field1Text) {
                          cartController.updateComment(
                              widget.producto, widget.comment, field1Text);
                        }
                      }
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Builder(builder: (context) {
                      String textOfbutton = 'Agregar';
                      if (widget.isPedido == 0) {
                        textOfbutton = 'Modificar';
                      }
                      return Text(
                        textOfbutton,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                );
              }), // Agrega un espacio de 12.5 entre los botones
              SizedBox(width: 12.5),
            ],
          ),
        ),
      );
  }
}