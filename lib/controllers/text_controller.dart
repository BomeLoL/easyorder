import 'package:flutter/material.dart';

class TextController extends ChangeNotifier{
  final TextEditingController controller = TextEditingController();

  String submit(){
   String text = controller.text;
   return text;
  }
}