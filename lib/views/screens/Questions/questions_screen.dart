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
  int _expandedPanelIndex = -1; // -1 means no panel is expanded

  void _setExpandedPanel(int index) {
    setState(() {
      _expandedPanelIndex = _expandedPanelIndex == index ? -1 : index;
    });
  }

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
            info: pedidoInstructions,
            isExpanded: _expandedPanelIndex == 0,
            onExpansionChanged: () => _setExpandedPanel(0),
          ),
          ExpandableInfoPanel(
            title: '¿Cómo recargar la billetera?',
            icon: Icon(
              Icons.wallet,
              color: primaryColor,
            ),
            info: rechargeInstructions,
            isExpanded: _expandedPanelIndex == 1,
            onExpansionChanged: () => _setExpandedPanel(1),
          ),
          ExpandableInfoPanel(
            title: '¿Cómo pagar?',
            icon: Icon(
              Icons.payments,
              color: primaryColor,
            ),
            info: paymentIstructions,
            isExpanded: _expandedPanelIndex == 2,
            onExpansionChanged: () => _setExpandedPanel(2),
          )
        ],
      ),
    );
  }
}
