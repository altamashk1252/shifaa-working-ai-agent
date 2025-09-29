// lib/controllers/sos_ctrl.dart
import 'package:flutter/foundation.dart';

class SosCtrl extends ChangeNotifier {
  bool _isActive = false;

  bool get isActive => _isActive;

  void activate() {
    _isActive = true;
    notifyListeners();
  }

  void deactivate() {
    _isActive = false;
    notifyListeners();
  }
}
