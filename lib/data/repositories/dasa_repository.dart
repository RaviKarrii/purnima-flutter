import '../api_client.dart';
import '../models/dasa_model.dart';

class DasaRepository {
  final ApiClient _apiClient;

  DasaRepository(this._apiClient);

  Future<List<DasaResult>> getVimshottariDasa(String birthTime, double lat, double lng, String timezone, String language) async {
    return await _apiClient.getVimshottariDasa(birthTime, lat, lng, timezone, language);
  }
}
