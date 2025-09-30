// lib/controllers/sos_ctrl.dart
import 'package:flutter/foundation.dart';

import '../services/locationService.dart';

class SosCtrl extends ChangeNotifier {
  bool _isActive = false;

  bool get isActive => _isActive;

  void activate() {
    _isActive = true;
    LocationService().startLocationUpdates();
    notifyListeners();
  }

  void deactivate() {
    _isActive = false;
    LocationService().stopLocationUpdates();

    notifyListeners();
  }
}
