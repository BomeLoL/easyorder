import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/clases/menu.dart';
import 'package:easyorder/controllers/categories_controller.dart';

class EditCategories extends StatefulWidget {
  const EditCategories(
      {super.key,
      required this.menu,
      required this.tipo,
      required this.categoria});

  final Menu menu;
  final int tipo;
  final List categoria;

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  late TextController textController;
  late CategoriesController categoriesController;
  late MenuEditController menuEditController;
  final _formKey = GlobalKey<FormState>();
  List<String> categorias = [];
  Map<String, bool> productos = {};
  String categoriaSelect = "";

  List cambiar = [];

  bool guardarPresionado = false;

  @override
  void initState() {
    super.initState();
    textController = Provider.of<TextController>(context, listen: false);
    menuEditController =
        Provider.of<MenuEditController>(context, listen: false);

    categoriesController =
        Provider.of<CategoriesController>(context, listen: false);
    categoriesController.categories!.forEach((item) {
      categorias.add(item);
    });

    if (categorias.isNotEmpty && (widget.tipo == 1 || widget.tipo == 2)) {
      categoriaSelect = categorias[0];
    }

    if (widget.tipo == 0) {
      textController.getController("New_Categoria").clear();
      categoriaSelect = "Nueva Categoria";
    } else if (widget.tipo == 1 || widget.tipo == 2) {
      textController.getController("New_Categoria").text = categoriaSelect;
    }
    updateProductos();
  }

  void updateProductos() {
    setState(() {
      productos.clear();
      widget.menu.itemsMenu.forEach((item) {
        productos[item.nombreProducto] = item.categoria == categoriaSelect;
      });
    });
  }

  String? categoriaValidator(String? value, String existingCategoryMessage1, String existingCategoryMessage2, String newCategory) {
    if (value == null || value.trim().isEmpty) {
    return existingCategoryMessage1;
    }

     if (widget.tipo == 1 || widget.tipo == 2) {
    // no puede escoger un nombre que ya sea una categoria
    if (categorias.contains(value.trim().replaceRange(0, 1, value[0].toUpperCase())) && value.trim().replaceRange(0, 1, value[0].toUpperCase()) != categoriaSelect) {
      return existingCategoryMessage2;
    }
  } else if (widget.tipo == 0) {
    //no crear una categoria que ya existe
    if (categorias.contains(value.trim().replaceRange(0, 1, value[0].toUpperCase()))) {
      return existingCategoryMessage2;
    }
  }
    return null;
}


  @override
  void dispose() {
    textController.getController("New_Categoria").clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textController = Provider.of<TextController>(context);
    if (widget.tipo == 1) {
      //se va editar
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil((route) {
            return route.settings.name == 'menu';
          });

          return await true;
        },
        child: Consumer2<CategoriesController, MenuEditController>(builder:
            (context, categoriesController, menuEditController, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Color.fromARGB(0, 255, 255, 255),
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Editar Categorias",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 100, right: 16, left: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    showCategorias(context),
                    SizedBox(height: 30),
                    editCategoriaField(context, textController),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Productos",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    showProductos(context),
                    SizedBox(height: 50),
                    save_exit_button(context),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else if (widget.tipo == 0) {
      // se va a crear nueva categoria
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil((route) {
            return route.settings.name == 'menu';
          });

          return await true;
        },
        child: Consumer<CategoriesController>(
            builder: (context, categoriesController, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Color.fromARGB(0, 255, 255, 255),
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Crear Categoria",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 100, right: 16, left: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    editCategoriaField(context, textController),
                    SizedBox(height: 50),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Productos",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    showProductos(context),
                    SizedBox(height: 90),
                    save_exit_button(context),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else if (widget.tipo == 2) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil((route) {
            return route.settings.name == 'menu';
          });

          return await true;
        },
        child: Consumer2<CategoriesController, MenuEditController>(builder:
            (context, categoriesController, menuEditController, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Color.fromARGB(0, 255, 255, 255),
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Eliminar Categoria",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 100, right: 16, left: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    showCategorias(context),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Productos",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    showProductos(context),
                    SizedBox(height: 50),
                    save_exit_button(context),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return Container();
    }
  }

  Widget showCategorias(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Categoría",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: categorias.contains(categoriaSelect)
                    ? categoriaSelect
                    : null,
                icon: Icon(Icons.keyboard_arrow_down),
                items: categorias.map((String categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    cambiar.clear();
                    categoriaSelect = newValue!;
                    textController.getController("New_Categoria").text =
                        categoriaSelect;
                    updateProductos();
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget editCategoriaField(BuildContext context, textController) {
    if (widget.tipo == 1) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nombre *",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomTextFormField(
              controller: textController.getController("New_Categoria"),
              hintText: categoriaSelect,
              validator: (value) => categoriaValidator(value,'Por favor ingrese un nombre para la categoria' ,'La categoría ingresada ya existe',textController.getText("New_Categoria")),
            ),
          ],
        ),
      );
    } else if (widget.tipo == 0) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nombre *",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            CustomTextFormField(
              controller: textController.getController("New_Categoria"),
              hintText: "Nombre de la nueva categoría",
              validator: (value) => categoriaValidator(value,'Por favor ingrese un nombre para la categoria' ,'La categoría ingresada ya existe.',textController.getText("New_Categoria")),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProductos(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: productos.keys.map((nombreP) {
          if (widget.tipo == 0) {
            //creando categoria
            return CheckboxListTile(
              activeColor: primaryColor,
              title: Text(nombreP),
              value: productos[nombreP],
              onChanged: (bool? value) {
                setState(() {
                  productos[nombreP] = value ?? false;
                  if (value == false) {
                    // Si se desmarca el producto lo metemos en cambiar para cambiar al darle a guardar
                    widget.menu.itemsMenu.forEach((producto) {
                      if (producto.nombreProducto == nombreP &&
                          producto.categoria == categoriaSelect) {
                        cambiar.add(producto);
                      }
                    });
                  }
                });
              },
            );
          } else if (widget.tipo == 1 || widget.tipo == 2) {
            return CheckboxListTile(
              activeColor: primaryColor,
              title: Text(nombreP),
              value: productos[nombreP],
              onChanged: (bool? value) {
                setState(() {
                  productos[nombreP] = value ?? false;
                  if (value == false) {
                    // Si se desmarca el producto lo metemos en cambiar para cambiar al darle a guardar
                    widget.menu.itemsMenu.forEach((producto) {
                      if (producto.nombreProducto == nombreP &&
                          producto.categoria == categoriaSelect) {
                        cambiar.add(producto);
                      }
                    });
                  }
                });
              },
            );
          }
          return Container();
        }).toList(),
      ),
    );
  }

  Widget save_exit_button(BuildContext context) {
    String texto;
    if (widget.tipo == 2) {
      texto = "Eliminar";
    } else {
      texto = "Guardar";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 150,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) {
                return route.settings.name == 'menu';
              });

              menuEditController.selectedCategoria = "Todo";
            },
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                  color: const Color.fromRGBO(255, 96, 4, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
        SizedBox(width: 40),
        Container(
          height: 50,
          width: 150,
          child: ElevatedButton(
            onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
              if (widget.tipo == 1 && _formKey.currentState!.validate()) {
                //editar
                categoriesController.editarCategoria(
                    textController.getText("New_Categoria"),
                    productos,
                    cambiar,
                    categoriaSelect,
                    menuEditController.menu!,
                    categorias);
                menuEditController.selectedCategoria = "Todo";

                Navigator.of(context).popUntil((route) {
                  return route.settings.name == 'menu';
                });
              } else if (widget.tipo == 0 && _formKey.currentState!.validate()) {
                //crear
                  categoriesController.crearCategoria(
                      textController.getText("New_Categoria"),
                      productos,
                      menuEditController.menu!,
                      categorias);
                  menuEditController.selectedCategoria = "Todo";
                  Navigator.of(context).popUntil((route) {
                    return route.settings.name == 'menu';
                  });
              } else if (widget.tipo == 2) {
                categoriesController.eliminarCategoria(
                    textController.getText("New_Categoria"),
                    productos,
                    menuEditController.menu!,
                    categorias);
                menuEditController.selectedCategoria = "Todo";
                Navigator.of(context).popUntil((route) {
                  return route.settings.name == 'menu';
                });
              }

              if (_formKey.currentState!=null && !_formKey.currentState!.validate()) {
                textController.getController("New_Categoria").clear();

              }
            }},
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 96, 4, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Text(
              texto,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
