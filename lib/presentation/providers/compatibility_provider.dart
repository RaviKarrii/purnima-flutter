import 'package:flutter/material.dart';
import '../../data/models/compatibility_model.dart';
import '../../data/repositories/compatibility_repository.dart';

class CompatibilityProvider with ChangeNotifier {
  final CompatibilityRepository _repository;
  CompatibilityResult? _result;
  bool _isLoading = false;
  String? _error;

  CompatibilityProvider(this._repository);

  CompatibilityResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearResult() {
    _result = null;
    _error = null;
    notifyListeners();
  }

  Future<void> calculateCompatibility({
    required BirthDataInput maleData,
    required BirthDataInput femaleData,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _result = await _repository.getCompatibility(maleData, femaleData);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
