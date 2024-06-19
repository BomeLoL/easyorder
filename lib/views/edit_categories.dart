import 'package:easyorder/controllers/text_controller.dart';
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
  const EditCategories({super.key, required this.menu, required this.tipo, required this.categoria});

  final Menu menu;
  final int tipo;
  final List categoria;

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  // final TextEditingController textFieldController = TextEditingController();
  late TextController textController;

  CategoriesController categoriesController = CategoriesController();

  List<String> categorias = [];
  Map<String, bool> productos = {};
  String categoriaSelect = "";

  List cambiar=[];

  bool guardarPresionado = false;

  @override
  void initState() {
    super.initState();
    textController = Provider.of<TextController>(context, listen: false);
    widget.categoria.forEach((item){
      categorias.add(item);
    });
    // categorias = widget.menu.itemsMenu.map((item) => item.categoria).toSet().toList();
    if (categorias.isNotEmpty) {
      categoriaSelect = categorias[0];
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
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Categorias",
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
    } else if (widget.tipo == 0) {
      // se va a crear nueva categoria
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Categorias",
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
                value: categoriaSelect,
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
      return Column(
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
          TextField(
            controller: textController.getController("New_Categoria"),
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: Colors.black,
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
              ),
              hintText: categoriaSelect,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14.0,
                color: Colors.black38,
              ),
            ),
          ),
        ],
      );
    } else if (widget.tipo == 0) {
      textController.getController("New_Categoria").clear();
      return Column(
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
          TextField(
            controller: textController.getController("New_Categoria"),
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: Colors.black,
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
              ),
              hintText: "Nombre de la nueva categoría",
              hintStyle: GoogleFonts.poppins(
                fontSize: 14.0,
                color: Colors.black38,
              ),
            ),
          ),
        ],
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
        }).toList(),
      ),
    );
  }

  Widget save_exit_button(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 150,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
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
            onPressed: () {
              if (widget.tipo == 1) { //editar
                categoriesController.editarCategoria(
                    textController.getController("New_Categoria").text,
                    productos, cambiar, categoriaSelect, widget.menu, categorias);
                Navigator.pop(context);
              } else if (widget.tipo == 0) {

              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 96, 4, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Text(
              'Guardar',
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
