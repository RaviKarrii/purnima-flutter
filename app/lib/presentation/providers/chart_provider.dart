import 'package:flutter/material.dart';
import '../../data/models/chart_model.dart';
import '../../data/repositories/chart_repository.dart';
import 'settings_provider.dart';

class ChartProvider with ChangeNotifier {
  ChartRepository _repository;
  SettingsProvider? _settings; // Added this field
  ChartResult? _chart;
  bool _isLoading = false;
  String? _error;

  // Store last params for reloading
  String? _lastBirthTime;
  double? _lastLat;
  double? _lastLng;
  String? _lastPlaceName;

  String _currentLanguage = 'en';

  ChartProvider(this._repository);

  void update(ChartRepository repository, SettingsProvider settings) {
    final newLanguage = settings.language;
    final languageChanged = _currentLanguage != newLanguage;
    _repository = repository;
    _settings = settings;
    _currentLanguage = newLanguage;

    if (languageChanged && _chart != null && _lastBirthTime != null) {
      loadChart(_lastBirthTime!, _lastLat!, _lastLng!, _lastPlaceName!);
    }
  }

  ChartResult? get chart => _chart;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChart(String birthTime, double lat, double lng, String placeName) async { // Changed 'place' to 'placeName'
    _isLoading = true;
    _error = null;
    
    // Update last params
    _lastBirthTime = birthTime;
    _lastLat = lat;
    _lastLng = lng;
    _lastPlaceName = placeName;

    notifyListeners();

    try {
      // Get timezone offset in +HH:mm or -HH:mm format
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final hours = offset.inHours.abs().toString().padLeft(2, '0');
      final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
      final sign = offset.isNegative ? '-' : '+';
      final timezone = '$sign$hours:$minutes';

      _chart = await _repository.getChart(
        birthTime, 
        lat, 
        lng, 
        placeName,
        _settings?.language ?? 'en',
        timezone,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
