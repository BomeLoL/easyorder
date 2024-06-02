import 'package:easyorder/views/menu.dart';
import 'package:easyorder/views/pantallaCarga.dart';
import 'package:flutter/material.dart';

class BotonEnvio extends StatelessWidget {
  BotonEnvio({super.key});
  bool funciona = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Detalles del Pedido',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 96, 4, 1),
      ),
      body: Center(
        child: Container(
            /*
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(255, 209, 189, 188),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 96, 4, 1),
                ),
                onPressed: () {},
                child: Text(
                  "Ordenar Pedido",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        */
            ),
      ),
      floatingActionButton: Container(
        width: 300,
        height: 50,
        child: FloatingActionButton.large(
          /*Parte importante del botón:
            El botón va a cambiar el contexto de la página a la pantalla de Carga
            Después llama a la BD para ponerle el pedido que acaba de realizar
            En caso de que la petición sea exitosa, se muestra el mensaje de función exitosa y se lleva al menú
            En caso contrario, se lleva al usuario a donde estaba, y se muestra un mensaje de error          
          */
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const pantallaCarga();
              }),
            );
            //Se hace una pequeña espera a la base de datos y después se continúa
            await Future.delayed(const Duration(seconds: 5));
            if (funciona) {
              Navigator.pop(context);
              _showSuccessDialog(context);
            } else {
              Navigator.pop(context);
              _showAlertDialog(context);
            }
          },
          backgroundColor: Color.fromRGBO(255, 96, 4, 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Center(
            child: Text(
              'Ordenar Pedido',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Esta función muestra el mensaje de error de cuando la orden falla
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ERROR!!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Hubo un error procesando tu orden, por favor, inténtelo de nuevo',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 96, 4, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //Esta función muestra la ventanilla que indica que la orden fue completada exitosamente
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pedido completado!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Ya tu pedido está en la cocina y estará listo dentro de poco',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          //  return 
            
            
            //MenuView(info: restaurante.id, restaurante: restaurante,menu: menu,);
            //}));
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 96, 4, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
