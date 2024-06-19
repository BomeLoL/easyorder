import 'package:flutter/foundation.dart';

class NavController extends ChangeNotifier{
  bool _isWalletSelected = false;
  int _selectedIndex = 0;

  bool get isWalletSelected => _isWalletSelected;
  int get selectedIndex => _selectedIndex;

  set isWalletSelected(bool value) {
    _isWalletSelected = value;
    notifyListeners();
  }

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}