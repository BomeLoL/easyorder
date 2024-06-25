import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easyorder/models/clases/item_menu.dart';
import 'dart:io';

class ProductImage extends StatefulWidget {
  final ItemMenu? producto;
  final ValueNotifier<bool> imageSelected;
  ValueNotifier<File?> image;
  final Function(File?) onImageChanged;
  ProductImage({super.key, required this.producto, required this.imageSelected, required this.image, required this.onImageChanged});

  @override
  State<ProductImage> createState() => _ProductImageState();
  
}


class _ProductImageState extends State<ProductImage> {

  
  Future<XFile?> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        widget.image.value = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
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
                        if (widget.image.value != null ||
                            widget.producto != null && widget.image.value == null) {
                          widget.imageSelected.value = true;
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
                                child: widget.image.value != null
                                    ? Image.file(
                                        widget.image.value!,
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
                
              ],
            );   
  }
}