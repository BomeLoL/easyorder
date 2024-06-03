import 'package:easyorder/models/dbHelper/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DbErrorDialog extends StatefulWidget {
  @override
  _DbErrorDialogState createState() => _DbErrorDialogState();
}

class _DbErrorDialogState extends State<DbErrorDialog> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Error en la conexión',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(),
      ),
      content: Text(
        'Verifique su conexión y presione el botón para intentarlo nuevamente. Por favor, espere unos segundos para reestablecer la conexión.',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: isButtonPressed ? null : () async {
              setState(() {
                isButtonPressed = true;
              });
              try {
                await MongoDatabase.connect();
              } catch (e) {}
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
