import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/screens/Questions/components/expandable_info_panel.dart';
import 'package:easyorder/views/screens/Questions/components/instructions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Preguntas frecuentes',
          style: titleStyle,
        ),
      ),
      body: ListView(
        children: [
          ExpandableInfoPanel(
              title: '¿Cómo hacer un pedido?',
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: primaryColor,
              ),
              info: pedidoInstructions),
          ExpandableInfoPanel(
              title: '¿Cómo recargar la billetera?',
              icon: Icon(
                Icons.wallet,
                color: primaryColor,
              ),
              info: rechargeInstructions),
          ExpandableInfoPanel(
              title: '¿Cómo pagar?',
              icon: Icon(
                Icons.payments,
                color: primaryColor,
              ),
              info: paymentIstructions)
        ],
      ),
    );
  }

  Widget _buildButton(String title, Icon icon, String description) {
    return Container(
      height: 90,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon,
        onPressed: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: BeveledRectangleBorder(),
            overlayColor: Colors.deepOrange.shade100),
        label: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
