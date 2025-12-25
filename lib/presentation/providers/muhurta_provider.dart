import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/muhurta_model.dart';
import '../../data/repositories/muhurta_repository.dart';
import 'settings_provider.dart';

class MuhurtaProvider with ChangeNotifier {
  MuhurtaRepository _repository;
  SettingsProvider _settings;
  MuhurtaResult? _muhurta;
  bool _isLoading = false;
  String? _error;
  String _currentLanguage = 'en';

  // Store last used params
  double? _lastLat;
  double? _lastLng;

  MuhurtaProvider(this._repository, this._settings) {
    _currentLanguage = _settings.language;
  }

  void update(MuhurtaRepository repository, SettingsProvider settings) {
    final newLanguage = settings.language;
    final languageChanged = _currentLanguage != newLanguage;
    _repository = repository;
    _settings = settings;
    _currentLanguage = newLanguage;

    if (languageChanged && _muhurta != null && _lastLat != null) {
      loadMuhurta(_lastLat!, _lastLng!);
    }
  }

  MuhurtaResult? get muhurta => _muhurta;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Date state
  DateTime _selectedDate = DateTime.now();

  Future<void> setDate(DateTime date) async {
    _selectedDate = date;
    if (_lastLat != null && _lastLng != null) {
      await loadMuhurta(_lastLat!, _lastLng!);
    }
  }

  Future<void> loadMuhurta(double lat, double lng) async {
    _isLoading = true;
    _error = null;
    _lastLat = lat;
    _lastLng = lng;
    notifyListeners();

    try {
      final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
      
      // Get timezone offset
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final hours = offset.inHours.abs().toString().padLeft(2, '0');
      final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
      final sign = offset.isNegative ? '-' : '+';
      final timezone = '$sign$hours:$minutes';

      _muhurta = await _repository.getMuhurta(
        date,
        lat,
        lng,
        timezone,
        _settings.language,
      );
    } catch (e) {
      print("[MuhurtaProvider] ERROR: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<MuhurtaSlot>? _advancedMuhurta;
  List<MuhurtaSlot>? get advancedMuhurta => _advancedMuhurta;

  Future<void> loadAdvancedMuhurta({
    required String type,
    required DateTime start,
    required DateTime end,
    required double lat,
    required double lng,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final startStr = start.toIso8601String();
      final endStr = end.toIso8601String();

      // Get timezone offset
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final hours = offset.inHours.abs().toString().padLeft(2, '0');
      final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
      final sign = offset.isNegative ? '-' : '+';
      final timezone = '$sign$hours:$minutes';

      _advancedMuhurta = await _repository.getAdvancedMuhurta(
        type,
        startStr,
        endStr,
        lat,
        lng,
        timezone,
        _settings.language,
      );
    } catch (e) {
      print("[MuhurtaProvider] Advanced ERROR: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
