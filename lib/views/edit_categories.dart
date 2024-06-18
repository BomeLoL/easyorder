import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/clases/menu.dart';


class EditCategories extends StatefulWidget {
  const EditCategories({super.key, required this.menu});

  final Menu menu;

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  final TextEditingController textFieldController = TextEditingController();

  List<String> categorias = [];

  // List<String> categorias = [
  //   'Pasta',
  //   'Pescado',
  //   'Parrilla',
  //   'Postre',
  //   'Postree',
  //   'Postreee',
  //   'Postreeee',
  //   'Postreeeee',
  //   'Postreeeeee',
  //   'Postreeeeeee',
  //   'Postreeeeeeee',
  //   'Postreeeeeeeee',
  //   'Postreeeeeeeeee',
  //   'Postreeeeeeeeeee',
  //   'Postreeeeeeeeeeee',
  //   'Postreeeeeeeeeeeeee',
  //   'Postreeeeeeeeeeeeeee',
  //   'Postreeeeeeeeeeeeeeee',
  //   'Postreeeeeeeeeeeeeeeee',
  //   'Postreeeeeeeeeeeeeeeeee',
  //   'Postreeeeeeeeeeeeeeeeeee',
  // ];

  String categoriaSelect = "";

  Map<String, bool> productos = {
    "Parrilla Guanteña": false,
    "Ensalada Cesar": false,
    "Jugo de naranja": false,
    "Quesillo": false,
    "Quesilloo": false,
    "Quesillooo": false,
    "Quesilloooo": false,
    "Quesilloooooo": false,
  };

  @override
  void initState() {
    super.initState();
        for (var elemento in widget.menu.itemsMenu) {
      categorias.add(elemento.categoria);
      categoriaSelect = categorias[0];
      textFieldController.text = categoriaSelect;
    }
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "Categorias",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
          right: 16,
          left: 16,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            showCategorias(context),
            SizedBox(
              height: 40,
            ),
            editCategoriaField(context),
            SizedBox(
              height: 40,
            ),
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
            SizedBox(
              height: 10,
            ),
            showProductos(context),

            SizedBox(height: 50,),
            save_exit_button(context)
          ],
        ),
      ),
    );
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
        SizedBox(
          height: 10,
        ),
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
                    categoriaSelect = newValue!;
                    textFieldController.text = categoriaSelect;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget editCategoriaField(BuildContext context) {
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
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: textFieldController,
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
  }

  Widget showProductos(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 2
        )
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: productos.keys.map((item) {
                return CheckboxListTile(
                  activeColor: primaryColor,
                  title: Text(item),
                  value: productos[item]!,
                  onChanged: (bool? value) {
                    setState(() {
                      print("PRIMEROOOOOOO ${productos[item]}");
                      productos[item] = value ?? false;
                      print("SEGUNDOOOOO ${productos[item]}");
                    });
                  },
                );
              }).toList(),
            ),
          );
        },
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
            onPressed: () {},
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
        SizedBox(
          width: 40,
        ),
        Container(
          height: 50,
          width: 150,
          child: ElevatedButton(
            onPressed: () {},
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