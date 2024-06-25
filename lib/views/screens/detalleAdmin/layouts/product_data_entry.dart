import 'package:flutter/material.dart';
import 'package:easyorder/controllers/categories_controller.dart';
import 'package:easyorder/controllers/text_controller.dart';
import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easyorder/models/clases/item_menu.dart';

class ProductDataEntry extends StatefulWidget {

  final ValueNotifier<String?> selectedCategory;
  final TextController controller;
  final ItemMenu? producto;
  final ValueNotifier<bool> imageSelected;
  final formKey;
   final Function(String?) onCategoryChanged;

  ProductDataEntry({super.key, required this.selectedCategory, required this.controller, required this.producto, required this.imageSelected, required this.formKey, required this.onCategoryChanged});

  @override
  State<ProductDataEntry> createState() => _ProductDataEntryState();
}

class _ProductDataEntryState extends State<ProductDataEntry> {

  String? TextValidator(String? value, String existingCategoryMessage1) {
    if (value == null || value.trim().isEmpty) {
      return existingCategoryMessage1;
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      if (!widget.imageSelected.value && widget.producto == null)
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
                            key: widget.formKey,
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
                                      widget.controller.getController('nombre'),
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
                                  controller: widget.controller.getController('precio'),
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
                                  controller: widget.controller
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
                                          value: widget.selectedCategory.value,
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
                                              widget.selectedCategory.value = value;
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
                );
  }
}