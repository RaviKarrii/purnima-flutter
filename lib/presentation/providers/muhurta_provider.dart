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

  Future<void> loadMuhurta(double lat, double lng) async {
    _isLoading = true;
    _error = null;
    _lastLat = lat;
    _lastLng = lng;
    notifyListeners();

    try {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
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
}
