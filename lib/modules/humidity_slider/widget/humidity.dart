import 'package:flutter/widgets.dart';

class Humidity with ChangeNotifier {
  int hum;
  Humidity({required this.hum}) {
    _defaultValue = hum;
    _transitionalValue = _defaultValue.toDouble();
    _finalValue = _defaultValue;
  }

  int _defaultValue = 37;

  double _transitionalValue = 0;
  double get transitionalValue => _transitionalValue;

  int _finalValue = 5;
  int get finalValue => _finalValue;

  void updateTrasitionalValue(double newValue) {
    _transitionalValue = newValue;
    notifyListeners();
  }

  void updateFinalValue() {
    _finalValue = _transitionalValue.round();
    notifyListeners();
  }
}
