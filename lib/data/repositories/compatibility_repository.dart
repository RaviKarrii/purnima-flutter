import '../api_client.dart';
import '../models/compatibility_model.dart';
class CompatibilityRepository {
  final ApiClient _apiClient;

  CompatibilityRepository(this._apiClient);

  Future<CompatibilityResult> getCompatibility(BirthDataInput maleData, BirthDataInput femaleData, String language) async {
    return await _apiClient.getCompatibility(maleData, femaleData, language);
  }
}
