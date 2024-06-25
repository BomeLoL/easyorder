import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/edit_product_card.dart';
import 'package:easyorder/views/Widgets/productCard/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  final String nombreRes;
  final String restauranteId;
  const ProductsList({required this.nombreRes, required this.restauranteId});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer2<MenuEditController, UserController>(
          builder: (context, menuController, userController, child) {
        if (menuController.menu!.itemsMenu.length > 0) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.zero,
            itemCount: menuController.menu!.itemsMenu.length,
            itemBuilder: (context, index) {
              if (menuController.selectedCategoria == "Todo" ||
                  menuController.menu!.itemsMenu[index].categoria ==
                      menuController.selectedCategoria) {
                return Column(
                  children: [
                    userController.usuario?.usertype == 'Restaurante'
                        ? EditProductCard(
                            producto: menuController.menu!.itemsMenu[index],
                            info: widget.nombreRes,
                            idRestaurante: widget.restauranteId,
                          )
                        : MenuCard(
                            producto: menuController.menu!.itemsMenu[index],
                            info: widget.nombreRes),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container(
            child: Center(
              child: Container(
                width: 200,
                child: Opacity(
                  opacity: 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        child: Image.asset('images/notFound.png'),
                      ),
                      Text(
                        'No se encontraron productos para este restaurante',
                        style: subtitleStyle2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}