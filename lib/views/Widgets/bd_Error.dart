import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DbErrorDialog extends StatefulWidget {
  @override
  _DbErrorDialogState createState() => _DbErrorDialogState();
}

class _DbErrorDialogState extends State<DbErrorDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Error en la conexión',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        'Verifique su conexión y presione el botón para intentarlo nuevamente. Por favor, espere unos segundos para reestablecer la conexión.',
        textAlign: TextAlign.justify,
      ),
      actions: [
        Center(
          child: isLoading 
          ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 96, 4, 1)),
          )
          :
          TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true; // Mostrar spinner
              });
              try {
                await MongoDatabase.connect();
              } catch (e) {

              } finally {
                setState(() {
                  isLoading = false; // Ocultar spinner
                });
              }
              Navigator.of(context).pop();
            },
            child: Text(
              'Volver a intentarlo',
              style: GoogleFonts.poppins(
                color: Color.fromRGBO(255, 96, 4, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void dbErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DbErrorDialog(); // Utiliza el widget StatefulWidget para mostrar el diálogo
    },
  );
}
