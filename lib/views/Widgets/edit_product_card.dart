import 'package:easyorder/models/clases/item_menu.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/product_card_base.dart';
import 'package:easyorder/views/detalleAdmin.dart';
import 'package:flutter/material.dart';

class EditProductCard extends ProductCardBase {
  EditProductCard({
    required ItemMenu producto,
    required String info,
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
                onPressed: () {
                  navigateToDetalleProducto(context);
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
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: primaryColor,
                ),
              ))
        ],
      ),
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
          info: info,
          producto: producto
        ),
      ),
    );
  }
}
