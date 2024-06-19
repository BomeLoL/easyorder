import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class detalleAdmin extends StatefulWidget {
  const detalleAdmin({super.key, this.producto = null, required this.idRestaurante});
  final ItemMenu? producto;
  final String idRestaurante;

  @override
  State<detalleAdmin> createState() => _detalleAdminState();
}

class _detalleAdminState extends State<detalleAdmin> {
  late TextController textController;
  final _formKey = GlobalKey<FormState>();
  late MenuEditController menuEditController;

  String? _selectedCategory;
  bool _categoryValid = true;
  bool _imageSelected = true;

  @override
  void initState() {
    super.initState();
    textController = Provider.of<TextController>(context, listen: false);
    menuEditController = Provider.of<MenuEditController>(context, listen: false);
  }

  @override
  void dispose() {
    textController.clearText('nombre');
    textController.clearText('precio');
    textController.clearText('descripcion');
    super.dispose();
  }

  File? _image;
  Future<XFile?> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Detalles del producto',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Container(
                      child: Builder(builder: (context) {
                        if (_image != null) {
                          _imageSelected = true;
                          return Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          );
                        } else {
                          return Container(
                            color: Colors.black12,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.upload,
                                      color: Colors.black54,
                                      // Icono de cámara

                                      size: 50,
                                      // Tamaño del icono
                                    ),
                                    SizedBox(height: 10),
                                    // Espacio entre el icono y el texto

                                    Text(
                                      'Selecciona la imagen del producto',
                                      // Texto
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      if (!_imageSelected)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Por favor, selecciona una imágen',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(35),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                //Icon(icon);
                                Text(
                                  'Nombre del producto *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                CustomTextFormField(
                                  controller:
                                      textController.getController('nombre'),
                                  hintText: 'Ej. Hamburguesa Clásica',
                                  validator:
                                      'Por favor, ingresa el nombre del producto',
                                ),

                                SizedBox(height: 25),

                                Text(
                                  'Precio *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                CustomTextFormField(
                                  controller:
                                      textController.getController('precio'),
                                  hintText: 'Ej. 12',
                                  keyboardType: TextInputType.number,
                                  validator: 'Por favor, ingresa el precio',
                                ),

                                SizedBox(height: 25),

                                Text(
                                  'Descripción *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                CustomTextFormField(
                                  controller:
                                      textController.getController('descripcion'),
                                  hintText:
                                      'Ej. Pan brioche, 200g de carne, lechuga, tomate, queso amarillo...',
                                  validator:
                                      'Por favor, ingresa la descripción',
                                ),

                                SizedBox(height: 25),
                                Text(
                                  'Categoría *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                DropdownButtonHideUnderline(
                                  child: Container(
                                    width: double
                                        .infinity, // This makes the dropdown width fit the screen
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: _categoryValid
                                              ? primaryColor
                                              : Colors
                                                  .red), // Set the border color
                                      borderRadius: BorderRadius.circular(
                                          4.0), // Optional: Add border radius
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.5),
                                      child: DropdownButton<String>(
                                        isExpanded:
                                            true, // This makes the dropdown width fit the screen
                                        value: _selectedCategory,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'item1',
                                            child: Text('Elemento 1'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'item2',
                                            child: Text('Elemento 2'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'item3',
                                            child: Text('Elemento 3'),
                                          ),
                                        ],
                                        hint: Text('Seleccionar categoría',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14)),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedCategory = value;
                                            _categoryValid =
                                                true; // Clear the error when a category is selected
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                if (!_categoryValid)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.5, vertical: 8.0),
                                    child: Text(
                                      'Por favor, selecciona una categoría',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.0,
                                        color: Colors.red.shade900,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          childCount: 1,
        ))
      ]),
      bottomNavigationBar: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _categoryValid = _selectedCategory != null;
                  _imageSelected = _image != null;
                });
                if (_formKey.currentState!.validate() &&
                    _categoryValid &&
                    _imageSelected) {
                      // Obtener el texto del campo
                      String precioTexto = textController.getText('precio');

                      // Reemplazar comas por puntos
                      precioTexto = precioTexto.replaceAll(',', '.');
                      final itemMenu = ItemMenu(
                      id: DateTime.now().millisecondsSinceEpoch, 
                      nombreProducto: textController.getText('nombre'),
                      descripcion: textController.getText('descripcion'),
                      precio: double.parse(precioTexto),
                      categoria: _selectedCategory!,
                      imgUrl: 'https://upload.wikimedia.org/wikipedia/en/f/fd/Logo_of_Stardew_Valley.png',
                    );
                    try {
                      await menuEditController.addProduct(widget.idRestaurante, itemMenu);
                      
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                    Navigator.pop(context);

                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  )),
              child: Text(
                'Guardar',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
