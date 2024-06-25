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
import 'package:easyorder/views/detalleAdmin/layouts/product_bottom_navigation.dart';
import 'package:easyorder/views/detalleAdmin/layouts/product_data_entry.dart';
import 'package:easyorder/views/detalleAdmin/layouts/product_image.dart';
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

  ValueNotifier<String?> _selectedCategory = ValueNotifier<String?>(null);
  ValueNotifier<bool> _imageSelected = ValueNotifier<bool>(true);


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
        _selectedCategory.value = null;
      } else {
        _selectedCategory.value = widget.producto!.categoria;
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

    ValueNotifier<File?> _image = ValueNotifier<File?>(null);



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
                ValueListenableBuilder<File?>(
                  valueListenable: _image,
                  builder: (context, image, child) {
                    return ProductImage(
                        producto: widget.producto,
                        imageSelected: _imageSelected,
                        image: _image,
                        onImageChanged: (newImage) {
                          _image.value = newImage;
                        });
                  },
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: _selectedCategory,
                  builder: (context, selectedCategory, child) {
                    return ProductDataEntry(
                        selectedCategory: _selectedCategory,
                        controller: textController,
                        producto: widget.producto,
                        imageSelected: _imageSelected,
                        formKey: _formKey,
                        onCategoryChanged: (newCategory) {
                          _selectedCategory.value = newCategory;
                        });
                  },
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
                        _imageSelected.value = _image.value != null;

                      });
                      if ((_formKey.currentState!.validate() &&
                              _imageSelected.value) ||
                          (_formKey.currentState!.validate() &&
                              widget.producto != null)) {
                        
                        String? imageURL;
                        String category;
                        if (_selectedCategory.value != null) {
                          category = _selectedCategory.value!;
                        } else {
                          category = '';
                        }
                        Provider.of<SpinnerController>(context, listen: false)
                            .setLoading(true);
                        // Obtener el texto del campo
                        String precioTexto = textController.getText('precio');
                        String nombre = textController.getText('nombre').trim();
                        if (widget.producto != null && _image.value == null) {
                          imageURL = widget.producto!.imgUrl;
                        } else {
                          imageURL =
                              await _firebaseService.uploadImage(_image.value!);
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
