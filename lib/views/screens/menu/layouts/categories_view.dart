import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  Set<String> categorias = Set<String>();
  int selectedIndex = -1;
  String selectedCategoria = "Todo";

   @override
  void initState() {
    super.initState();
    categorias.add("Todo");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Consumer2<MenuEditController, CategoriesController>(
          builder: (context, menuController, categoriesController, child) {
        if (categoriesController.categories == null) {
          return Container();
        }
        categorias.clear();
        categorias.add("Todo");
        for (var elemento in categoriesController.categories!) {
          categorias.add(elemento);
        }
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Row(
                children: categorias
                    .map((elemento) {
                      Color color = elemento == menuController.selectedCategoria
                          ? Color(0xFFFF5F04)
                          : Colors.white;
                      Color color1 =
                          elemento == menuController.selectedCategoria
                              ? Colors.white
                              : Colors.black;
                      return [
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                menuController.selectedCategoria = elemento;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: color1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size(45, 40),
                            ),
                            child: Text(elemento)),
                        SizedBox(
                          width: 10,
                        ),
                      ];
                    })
                    .expand((widgets) => widgets)
                    .toList()),
          ],
        );
      }),
    );
  }
}
