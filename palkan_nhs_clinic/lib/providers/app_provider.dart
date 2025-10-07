import 'package:flutter/foundation.dart';
import '../models/bmi.dart';

class AppProvider extends ChangeNotifier {
  BmiRecord? _latestBmi;
  int _pendingNotifications = 0;

  BmiRecord? get latestBmi => _latestBmi;
  int get pendingNotifications => _pendingNotifications;

  void setLatestBmi(BmiRecord record) {
    _latestBmi = record;
    notifyListeners();
  }

  void setPendingNotifications(int count) {
    _pendingNotifications = count;
    notifyListeners();
  }
}
