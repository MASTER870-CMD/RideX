import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EmissionStatusLevel { valid, dueSoon, dueToday, overdue }

class EmissionService extends ChangeNotifier {
  static const String _prefKey = 'emission_due_date';

  DateTime _dueDate = DateTime(2026, 10, 15); // Default mock date
  bool _remindersEnabled = true;

  DateTime get dueDate => _dueDate;
  bool get remindersEnabled => _remindersEnabled;

  int get daysRemaining => _dueDate.difference(_today).inDays;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  EmissionStatusLevel get statusLevel {
    final days = daysRemaining;
    if (days < 0) return EmissionStatusLevel.overdue;
    if (days == 0) return EmissionStatusLevel.dueToday;
    if (days <= 7) return EmissionStatusLevel.dueSoon;
    return EmissionStatusLevel.valid;
  }

  String get statusLabel {
    switch (statusLevel) {
      case EmissionStatusLevel.valid:    return 'VALID';
      case EmissionStatusLevel.dueSoon:  return 'DUE SOON';
      case EmissionStatusLevel.dueToday: return 'DUE TODAY';
      case EmissionStatusLevel.overdue:  return 'OVERDUE';
    }
  }

  String get daysLabel {
    final days = daysRemaining;
    if (days < 0) return '${days.abs()} days overdue';
    if (days == 0) return 'Due today';
    if (days == 1) return '1 day remaining';
    return '$days days remaining';
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefKey);
    if (stored != null) {
      _dueDate = DateTime.parse(stored);
      notifyListeners();
    }
  }

  Future<void> setDueDate(DateTime date) async {
    _dueDate = date;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, date.toIso8601String());
  }

  void toggleReminders() {
    _remindersEnabled = !_remindersEnabled;
    notifyListeners();
  }
}
