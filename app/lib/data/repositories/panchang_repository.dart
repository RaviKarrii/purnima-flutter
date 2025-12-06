import '../api_client.dart';
import '../models/panchang_model.dart';

class PanchangRepository {
  final ApiClient _apiClient;

  PanchangRepository(this._apiClient);

  Future<PanchangResult> getPanchang(String date, double lat, double lng, String placeName, String language, String timezone) async {
    return await _apiClient.getPanchang(date, lat, lng, placeName, language, timezone);
  }
}
