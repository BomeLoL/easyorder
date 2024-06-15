import 'package:flutter/material.dart';

class IconDisplay extends StatelessWidget {
  final String iconPath;
  final String text;

  const IconDisplay({required this.iconPath, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Expanded(
      

        child: Container(
          height: size.height * 0.075,
          decoration: BoxDecoration(
            
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10), // Ajusta el radio aquí
            border: Border.all(color: Colors.grey, width: 1.5),
          ),
          padding: EdgeInsets.all(12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Row al contenido
              mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido horizontalmente
              children: [
                Image.asset(
                  iconPath,
                  width: 30,
                  height: 40,
                ),
                SizedBox(width: 16), // Espacio entre el icono y el texto
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16, // Ajusta el tamaño de la fuente según sea necesario
                    color: Colors.black, 
                    fontWeight: FontWeight.w500 // Ajusta el peso de la fuente según sea necesario
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
