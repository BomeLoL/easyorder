import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/menu_edit_controller.dart';
import 'package:easyorder/controllers/spinner_controller.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/models/dbHelper/firebase_service.dart';
import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:easyorder/views/Widgets/bd_Error.dart';
import 'package:easyorder/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class detalleAdmin extends StatefulWidget {
  const detalleAdmin(
      {super.key, this.producto = null, required this.idRestaurante});
  final ItemMenu? producto;
  final String idRestaurante;

  @override
  State<detalleAdmin> createState() => _detalleAdminState();
}

class _detalleAdminState extends State<detalleAdmin> {
  late TextController textController;
  final _formKey = GlobalKey<FormState>();
  late MenuEditController menuEditController;
  final _firebaseService = FirebaseService();

  String? _selectedCategory;
  bool _imageSelected = true;

  @override
  void initState() {
    super.initState();
    textController = Provider.of<TextController>(context, listen: false);
    menuEditController =
        Provider.of<MenuEditController>(context, listen: false);
    if (widget.producto != null) {
      textController.getController('nombre').text =
          widget.producto!.nombreProducto;
      textController.getController('precio').text =
          widget.producto!.precio.toString();
      textController.getController('descripcion').text =
          widget.producto!.descripcion;
      if (widget.producto!.categoria == '') {
        _selectedCategory = null;
      } else {
        _selectedCategory = widget.producto!.categoria;
      }
    }
  }

  @override
  void dispose() {
    textController.clearText('nombre');
    textController.clearText('precio');
    textController.clearText('descripcion');
    super.dispose();
  }

  String? TextValidator(String? value, String existingCategoryMessage1) {
    if (value == null || value.trim().isEmpty) {
      return existingCategoryMessage1;
    }
    return null;
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
                        if (_image != null ||
                            widget.producto != null && _image == null) {
                          _imageSelected = true;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.upload,
                                          color: Colors.black,
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
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: _image != null
                                    ? Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      )
                                    : Image.network(
                                        widget.producto!.imgUrl,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      ),
                              ),
                            ],
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
                      if (!_imageSelected && widget.producto == null)
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
                                  validator: (value) => TextValidator(value,
                                      'Por favor, ingresa el nombre del producto'),
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
                                TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  controller: textController.getController('precio'),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  onChanged: (value) {},
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.0, color: Colors.black),
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                      errorStyle: GoogleFonts.poppins(),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                      hintText: 'Ej. 12',
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          color: Colors.black38)),
                                  validator: (value) => TextValidator(
                                      value, 'Por favor, ingresa el precio'),
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
                                  controller: textController
                                      .getController('descripcion'),
                                  hintText:
                                      'Ej. Pan brioche, 200g de carne, lechuga, tomate, queso amarillo...',
                                  validator: (value) => TextValidator(value,
                                      'Por favor, ingresa la descripción'),
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

                                Consumer<CategoriesController>(builder:
                                    (context, categoriesController, child) {
                                  return DropdownButtonHideUnderline(
                                    child: Container(
                                      width: double
                                          .infinity, // This makes the dropdown width fit the screen
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                primaryColor), // Set the border color
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
                                          items: categoriesController.categories
                                              ?.map<DropdownMenuItem<String>>(
                                                  (String category) {
                                            return DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(category),
                                            );
                                          }).toList(),
                                          hint: Text('Seleccionar categoría',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14)),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedCategory = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }),
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
          child: Consumer<SpinnerController>(
              builder: (context, spinnerController, child) {
            if (spinnerController.isLoading == true) {
              return Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              );
            } else {
              return Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                                      final tester = await MongoDatabase.Test();
                                      if (tester == false) {
                                        // ignore: use_build_context_synchronously
                                        dbErrorDialog(context);
                                      }else{
                      setState(() {
                        _imageSelected = _image != null;
                      });
                      if ((_formKey.currentState!.validate() &&
                              _imageSelected) ||
                          (_formKey.currentState!.validate() &&
                              widget.producto != null)) {
                        
                        String? imageURL;
                        String category;
                        if (_selectedCategory != null) {
                          category = _selectedCategory!;
                        } else {
                          category = '';
                        }
                        Provider.of<SpinnerController>(context, listen: false)
                            .setLoading(true);
                        // Obtener el texto del campo
                        String precioTexto = textController.getText('precio');
                        String nombre = textController.getText('nombre').trim();
                        if (widget.producto != null && _image == null) {
                          imageURL = widget.producto!.imgUrl;
                        } else {
                          imageURL =
                              await _firebaseService.uploadImage(_image!);
                        }

                        // Reemplazar comas por puntos
                        precioTexto = precioTexto.replaceAll(',', '.');
                        int id_p = DateTime.now().millisecondsSinceEpoch;
                        if (widget.producto != null) {
                          id_p = widget.producto!.id;
                        }
                        final itemMenu = ItemMenu(
                          id: id_p,
                          nombreProducto: nombre,
                          descripcion: textController.getText('descripcion'),
                          precio: double.parse(precioTexto),
                          categoria: category,
                          imgUrl: imageURL!,
                        );
                        try {
                          if (widget.producto != null) {
                            await menuEditController.editProduct(
                                widget.idRestaurante, itemMenu);
                          } else {
                            await menuEditController.addProduct(
                                widget.idRestaurante, itemMenu);
                          }
                          Provider.of<SpinnerController>(context, listen: false)
                              .setLoading(false);
                        } catch (e) {
                          Provider.of<SpinnerController>(context, listen: false)
                              .setLoading(false);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')));
                          
                        }
                        Navigator.pop(context);
                      }
                    }},
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
                    )),
              );
            }
          }),
        ),
      ),
    );
  }
}
