import 'package:flutter/material.dart';

class TextController with ChangeNotifier {
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController getController(String key) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController();
    }
    return _controllers[key]!;
  }

  String getText(String key) {
    return _controllers[key]?.text ?? '';
  }

  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void clearText(String key) {
    if (_controllers.containsKey(key)) {
      _controllers[key]?.text = '';
    }
  }

}