import 'package:dio/dio.dart';
import 'models/panchang_model.dart';
import 'models/chart_model.dart';
import 'models/dasa_model.dart';
import 'models/muhurta_model.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl = 'https://purnima.ravikarri.in';

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<PanchangResult> getPanchang(String date, double lat, double lng, String placeName, String language, String timezone) async {
    try {
      final response = await _dio.get(
        '/api/panchang',
        queryParameters: {
          'date': date,
          'latitude': lat,
          'longitude': lng,
          'placeName': placeName,
          'timezone': timezone,
        },
        options: Options(
          headers: {
            'Accept-Language': language,
          },
        ),
      );
      return PanchangResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load panchang: $e');
    }
  }

  Future<ChartResult> getChart(String birthTime, double lat, double lng, String placeName, String language, String timezone) async {
    try {
      final response = await _dio.get(
        '/api/chart',
        queryParameters: {
          'birthTime': birthTime,
          'latitude': lat,
          'longitude': lng,
          'placeName': placeName,
          'timezone': timezone,
        },
        options: Options(
          headers: {
            'Accept-Language': language,
          },
        ),
      );
      return ChartResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load chart: $e');
    }
  }

  Future<List<DasaResult>> getVimshottariDasa(String birthTime, double lat, double lng, String timezone, String language) async {
    try {
      final response = await _dio.get(
        '/api/dasa/vimshottari',
        queryParameters: {
          'birthTime': birthTime,
          'latitude': lat,
          'longitude': lng,
          'zoneId': timezone,
        },
        options: Options(
          headers: {
            'Accept-Language': language,
          },
        ),
      );
      return (response.data as List).map((e) => DasaResult.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load dasa: $e');
    }
  }

  Future<MuhurtaResult> getMuhurta(String date, double lat, double lng, String timezone, String language) async {
    try {
      final response = await _dio.get(
        '/api/muhurta/calculate',
        queryParameters: {
          'date': date,
          'latitude': lat,
          'longitude': lng,
          'zoneId': timezone,
        },
        options: Options(
          headers: {
            'Accept-Language': language,
          },
        ),
      );
      return MuhurtaResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load muhurta: $e');
    }
  }
}
