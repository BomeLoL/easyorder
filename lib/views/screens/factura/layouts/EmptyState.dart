import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyStateLayout extends StatelessWidget {
  const EmptyStateLayout({
    Key? key,
    required this.size,
    required this.onButtonPressed,
  }) : super(key: key);

  final Size size;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: kToolbarHeight + size.height * 0.03,
          ),
          Text(
            'Mis Pedidos',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
              height: size.height * 0.18), // Ajusta este tamaño para controlar la altura
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Image.asset(
                    'images/flyingHamburger.png', // Reemplaza con la ruta de tu imagen
                    height: size.height * 0.23, // Ajusta el tamaño de la imagen según lo necesites
                  ),
                ),
                const SizedBox(height: 10), // Espacio entre la imagen y el texto
                Text(
                  'Aún no has realizado pedidos',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6), // Espacio entre los textos
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Text(
                    'Busca entre todas nuestras opciones y disfruta de tu primer pedido',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.03),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5F04),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Realizar un Pedido",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.height * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
