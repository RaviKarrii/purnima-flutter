import '../api_client.dart';
import '../models/compatibility_model.dart';
import '../models/compatibility_model.dart'; // Duplicate import usually harmless but I should avoid

class CompatibilityRepository {
  final ApiClient _apiClient;

  CompatibilityRepository(this._apiClient);

  Future<CompatibilityResult> getCompatibility(BirthDataInput maleData, BirthDataInput femaleData) async {
    return await _apiClient.getCompatibility(maleData, femaleData);
  }
}
