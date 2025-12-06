import 'package:flutter/material.dart';
import '../../data/models/dasa_model.dart';
import '../../data/repositories/dasa_repository.dart';
import 'settings_provider.dart';

class DasaProvider with ChangeNotifier {
  DasaRepository _repository;
  SettingsProvider _settings;
  List<DasaResult>? _dasa;
  bool _isLoading = false;
  String? _error;
  String _currentLanguage = 'en';

  // Store last used params for refresh
  String? _lastBirthTime;
  double? _lastLat;
  double? _lastLng;

  DasaProvider(this._repository, this._settings) {
    _currentLanguage = _settings.language;
  }

  void update(DasaRepository repository, SettingsProvider settings) {
    final newLanguage = settings.language;
    final languageChanged = _currentLanguage != newLanguage;
    _repository = repository;
    _settings = settings;
    _currentLanguage = newLanguage;

    if (languageChanged && _dasa != null && _lastBirthTime != null) {
      loadDasa(_lastBirthTime!, _lastLat!, _lastLng!);
    }
  }

  List<DasaResult>? get dasa => _dasa;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDasa(String birthTime, double lat, double lng) async {
    _isLoading = true;
    _error = null;
    _lastBirthTime = birthTime;
    _lastLat = lat;
    _lastLng = lng;
    notifyListeners();

    try {
      // Get timezone offset
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final hours = offset.inHours.abs().toString().padLeft(2, '0');
      final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
      final sign = offset.isNegative ? '-' : '+';
      final timezone = '$sign$hours:$minutes';

      _dasa = await _repository.getVimshottariDasa(
        birthTime,
        lat,
        lng,
        timezone,
        _settings.language,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
