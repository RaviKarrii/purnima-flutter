import 'package:dio/dio.dart';
import 'models/panchang_model.dart';
import 'models/chart_model.dart';
import 'models/dasa_model.dart';
import 'models/muhurta_model.dart';
import 'models/compatibility_model.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl = 'https://purnima.ravikarri.in';

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 150); // Increased 5x for heavy calculations
    _dio.options.receiveTimeout = const Duration(seconds: 150);
  }


  Future<List<MuhurtaSlot>> getAdvancedMuhurta(
    String type,
    String start,
    String end,
    double lat,
    double lng,
    String zoneId,
    String language,
  ) async {
    try {
      final response = await _dio.get(
        '/api/muhurta/$type',
        queryParameters: {
          'start': start,
          'end': end,
          'latitude': lat,
          'longitude': lng,
          'zoneId': zoneId,
        },
        options: Options(
          headers: {
            'Accept-Language': language,
          },
        ),
      );
      
      if (response.data is List) {
        return (response.data as List).map((e) => MuhurtaSlot.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || 
            e.type == DioExceptionType.receiveTimeout || 
            e.type == DioExceptionType.sendTimeout) {
           throw Exception('Request timed out. The server took too long to respond. Please try a shorter date range.');
        }
      }
      throw Exception('Failed to load advanced muhurta: $e');
    }
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
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || 
            e.type == DioExceptionType.receiveTimeout || 
            e.type == DioExceptionType.sendTimeout) {
           throw Exception('Request timed out. The server took too long to calculate muhurta.');
        }
      }
      throw Exception('Failed to load muhurta: $e');
    }
  }


  Future<CompatibilityResult> getCompatibility(
    BirthDataInput maleData,
    BirthDataInput femaleData,
    String language,
  ) async {
    try {
      final response = await _dio.post(
        '/api/compatibility',
        data: {
          'maleBirthData': maleData.toJson(),
          'femaleBirthData': femaleData.toJson(),
        },
        options: Options(
          headers: {
            'Accept-Language': language,
          },
        ),
      );
      return CompatibilityResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to calculate compatibility: $e');
    }
  }
}

