import '../api_client.dart';
import '../models/chart_model.dart';

class ChartRepository {
  final ApiClient _apiClient;

  ChartRepository(this._apiClient);

  Future<ChartResult> getChart(String birthTime, double lat, double lng, String placeName, String language, String timezone) async {
    return await _apiClient.getChart(birthTime, lat, lng, placeName, language, timezone);
  }
}
