import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class detalleProducto extends StatefulWidget {
  const detalleProducto({super.key});

  @override
  State<detalleProducto> createState() => _detalleProductoState();
}

class textContainer extends StatelessWidget {
  const textContainer({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.color,
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.5),
      child: 
          Column(
            
            children: [
              Text(
                text,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: size,
                  fontWeight: weight,
                  color: color,
                ),
              ),
            ],
          ),

    );
  }
}

class quantityButton extends StatefulWidget {
  const quantityButton({super.key});

  @override
  State<quantityButton> createState() => _quantityButtonState();
}

class _quantityButtonState extends State<quantityButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove),
            style: IconButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 95, 4, 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                )),
            color: Color.fromRGBO(255, 95, 4, 1),
            iconSize: 20,
          ),
        ),
        const Gap(10),
        Text(
          '1',
          style: GoogleFonts.poppins(),
        ), //implementar funcionalidad
        const Gap(10),
        Container(
          width: 35,
          height: 35,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            style: IconButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 95, 4, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                )),
            color: Colors.white,
            iconSize: 20,
          ),
        ),
      ],
    );
  }
}

class _detalleProductoState extends State<detalleProducto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            body: NestedScrollView(
              headerSliverBuilder:(context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    collapsedHeight: 56,
                    expandedHeight: 400,
                    floating: false,
                    pinned: true,
                    scrolledUnderElevation: 0,
                    backgroundColor: innerBoxIsScrolled ? Colors.white : Color.fromARGB(0, 255, 255, 255),
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://recetasdeusa.com/wp-content/uploads/2022/05/Hamburguesa-americana-1-scaled.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                      ),
                    ),

                  )
                ];
              },
              body: SingleChildScrollView(
                        child: Column(
                          children: [
                            ClipRRect(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Column(children: [
                                    //Icon(icon);
                                    const textContainer(
                                        text: 'Hamburguesa Clásica',
                                        size: 25,
                                        weight: FontWeight.normal,
                                        color: Colors.black),
                                          
                                    textContainer(
                                        text: '\$12.99',
                                        size: 18,
                                        weight: FontWeight.bold,
                                        color: Colors.black),
                                          
                                    textContainer(
                                        text:
                                            'In a medium bowl, add ground chicken, breadcrumbs, mayonnaise, onions, parsley, garlic, paprika, salt and pepper. Use your hands to combine all the ingredients together until blended, but don\'t over mix.',
                                        size: 14,
                                        weight: FontWeight.normal,
                                        color: Colors.black),
                                    
                                    textContainer(
                                        text:
                                            'In a medium bowl, add ground chicken, breadcrumbs, mayonnaise, onions, parsley, garlic, paprika, salt and pepper. Use your hands to combine all the ingredients together until blended, but don\'t over mix.',
                                        size: 14,
                                        weight: FontWeight.normal,
                                        color: Colors.black),
                                    
                                    textContainer(
                                        text:
                                            'In a medium bowl, add ground chicken, breadcrumbs, mayonnaise, onions, parsley, garlic, paprika, salt and pepper. Use your hands to combine all the ingredients together until blended, but don\'t over mix.',
                                        size: 14,
                                        weight: FontWeight.normal,
                                        color: Colors.black),
                                            
                                    textContainer(
                                        text:
                                            'In a medium bowl, add ground chicken, breadcrumbs, mayonnaise, onions, parsley, garlic, paprika, salt and pepper. Use your hands to combine all the ingredients together until blended, but don\'t over mix.',
                                        size: 14,
                                        weight: FontWeight.normal,
                                        color: Colors.black),
                                          
                                    textContainer(
                                        text: 'Comentarios adicionales',
                                        size: 18,
                                        weight: FontWeight.bold,
                                        color: Colors.black),
                                          
                                    textContainer(
                                        text:
                                            'Hazle saber al restaurante los detalles a tener en cuenta al preparar tu pedido.',
                                        size: 14,
                                        weight: FontWeight.normal,
                                        color: Colors.black38),
                                          
                                    TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: '(Opcional)',
                                          hintStyle: const TextStyle(
                                              fontSize: 14.0, color: Colors.black38)),
                                    ),
                                          
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: quantityButton(),
                                          ),
                                          SizedBox(
                                              width:
                                                  12.5), // Agrega un espacio de 12.5 entre los botones
                                          Expanded(
                                            flex: 2,
                                            child: TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Color.fromRGBO(255, 95, 4, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        10.0), // Ajusta el padding vertical
                                                child: Text(
                                                  "Agregar",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Positioned(
                      //  top: 20,
                      //  left: 20,
                      //  child: IconButton(
                      //    icon: Icon(Icons.arrow_back),
                      //    onPressed: () {
                      //      // Handle button press
                      //    },
                      //    style: IconButton.styleFrom(
                      //      backgroundColor: Color.fromRGBO(255, 96, 4, 0.2),
                      //      shape: RoundedRectangleBorder(
                      //        borderRadius: BorderRadius.circular(7),
                      //      ),
                      //    ),
                      //  ),
                      //),
                    
            ),
            );
  }
}
