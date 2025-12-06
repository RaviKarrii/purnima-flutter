import '../api_client.dart';
import '../models/muhurta_model.dart';

class MuhurtaRepository {
  final ApiClient _apiClient;

  MuhurtaRepository(this._apiClient);

  Future<MuhurtaResult> getMuhurta(String date, double lat, double lng, String timezone, String language) async {
    return await _apiClient.getMuhurta(date, lat, lng, timezone, language);
  }
}
