import 'package:easyorder/models/dbHelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableInfoPanel extends StatefulWidget {
  final String title;
  final Icon icon;
  final String info;
   final bool isExpanded;
  final VoidCallback onExpansionChanged;
  const ExpandableInfoPanel({
    Key? key,
    required this.icon,
    required this.title,
    required this.info,
    required this.isExpanded,
    required this.onExpansionChanged,
  }) : super(key: key);

  @override
  State<ExpandableInfoPanel> createState() => _ExpandableInfoPanelState();
}

class _ExpandableInfoPanelState extends State<ExpandableInfoPanel> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: (panelIndex, isExpanded) {
          widget.onExpansionChanged();
        },
        children: [
          ExpansionPanel(
            backgroundColor: Colors.white,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: widget.icon,
                title: Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              );
            },
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                widget.info,
                style: normalTextStyle,
                textAlign: TextAlign.justify,
              ),
            ),
            isExpanded: widget.isExpanded,
          ),
        ],
      ),
    );
  }
}
