import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:easyorder/views/screens/Questions/components/expandable_info_panel.dart';
import 'package:easyorder/views/screens/Questions/components/instructions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyorder/controllers/user_controller.dart';
import 'package:provider/provider.dart';

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
    return Consumer<UserController>(
      builder: (context, userController, child) {
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
          body:  
          ListView(
            children: [
              if (userController.usuario?.usertype == 'Comensal'  || userController.usuario?.usertype == null) 
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
               if (userController.usuario?.usertype == 'Comensal' || userController.usuario?.usertype == null) 
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
               if (userController.usuario?.usertype == 'Comensal'  || userController.usuario?.usertype == null)
              ExpandableInfoPanel(
                title: '¿Cómo pagar?',
                icon: Icon(
                  Icons.payments,
                  color: primaryColor,
                ),
                info: paymentIstructions,
                isExpanded: _expandedPanelIndex == 2,
                onExpansionChanged: () => _setExpandedPanel(2),
              ),
              if (userController.usuario?.usertype == 'Restaurante')
              ExpandableInfoPanel(
                title: '¿Cómo agregar un producto?',
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: primaryColor,
                ),
                info: addProductInstructions,
                isExpanded: _expandedPanelIndex == 0,
                onExpansionChanged: () => _setExpandedPanel(0),
              ),
              if (userController.usuario?.usertype == 'Restaurante')
              ExpandableInfoPanel(
                title: '¿Cómo agregar una categoría?',
                icon: Icon(
                  Icons.add_circle,
                  color: primaryColor,
                ),
                info: addCategoryInstructions,
                isExpanded: _expandedPanelIndex == 1,
                onExpansionChanged: () => _setExpandedPanel(1),
              ),
              if (userController.usuario?.usertype == 'Restaurante')
              ExpandableInfoPanel(
                title: '¿Cómo registrar una mesa  y su respectivo QR?',
                icon: Icon(
                  Icons.table_bar,
                  color: primaryColor,
                ),
                info: addTableInstructions,
                isExpanded: _expandedPanelIndex == 2,
                onExpansionChanged: () => _setExpandedPanel(2),
              ),
              if (userController.usuario?.usertype == 'Restaurante')
              ExpandableInfoPanel(
                title: '¿Cómo modificar los datos de mi restaurante?',
                icon: Icon(
                  Icons.edit_note,
                  color: primaryColor,
                ),
                info: editDataInstructions,
                isExpanded: _expandedPanelIndex == 3,
                onExpansionChanged: () => _setExpandedPanel(3),
              )
            ],
          ),
        );
      }
    );
  }
}
