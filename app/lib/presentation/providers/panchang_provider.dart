import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../data/models/panchang_model.dart';
import '../../data/city_data.dart';
import '../../data/repositories/panchang_repository.dart';
import 'settings_provider.dart';

class PanchangProvider with ChangeNotifier {
  PanchangRepository _repository;
  SettingsProvider _settings;
  PanchangResult? _panchang;
  bool _isLoading = false;
  String? _error;

  String _currentLanguage = 'en';

  PanchangProvider(this._repository, this._settings) {
    _currentLanguage = _settings.language;
    print("PURNIMA_DEBUG: PanchangProvider created");
  }

  void update(PanchangRepository repository, SettingsProvider settings) {
    final newLanguage = settings.language;
    final languageChanged = _currentLanguage != newLanguage;
    _repository = repository;
    _settings = settings;
    _currentLanguage = newLanguage;
    
    if (languageChanged) {
      loadPanchang();
    }
  }

  PanchangResult? get panchang => _panchang;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Manual location state
  double? _manualLat;
  double? _manualLng;
  String? _manualPlace;
  bool _useManualLocation = false;

  Future<void> setManualLocation(double lat, double lng, String place) async {
    _manualLat = lat;
    _manualLng = lng;
    _manualPlace = place;
    _useManualLocation = true;
    await loadPanchang();
  }

  Future<void> useCurrentLocation() async {
    _useManualLocation = false;
    await loadPanchang();
  }

  Future<void> loadPanchang() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      double lat;
      double lng;
      String place;

      if (_useManualLocation && _manualLat != null && _manualLng != null) {
        lat = _manualLat!;
        lng = _manualLng!;
        place = _manualPlace ?? 'Manual Location';
      } else {
        // Check permissions
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception('Location permissions are denied');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are permanently denied');
        }

        // Get location
        final LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );
        
        lat = position.latitude;
        lng = position.longitude;
        
        final nearest = City.findNearestCity(lat, lng);
        place = nearest != null ? 'Near ${nearest.name}' : 'Current Location';
      }

      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Get timezone offset in +HH:mm or -HH:mm format
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final hours = offset.inHours.abs().toString().padLeft(2, '0');
      final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
      final sign = offset.isNegative ? '-' : '+';
      final timezone = '$sign$hours:$minutes';

      _panchang = await _repository.getPanchang(
        date,
        lat,
        lng,
        place,
        _settings.language,
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
