import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/models/panchang_model.dart';

void main() {
  group('PanchangResult', () {
    test('fromJson parses complete JSON correctly', () {
      final json = <String, dynamic>{
        "tithi": {"name": "Tithi 1", "number": 1, "endTime": "10:00"},
        "vara": {"name": "Sunday", "number": 1},
        "nakshatra": {"name": "Ashwini", "number": 1, "endTime": "11:00"},
        "yoga": {"name": "Vishkumbha", "number": 1, "endTime": "12:00"},
        "karana": {"name": "Bava", "number": 1, "endTime": "13:00"},
        "sunrise": "06:00",
        "sunset": "18:00",
        "moonrise": "20:00",
        "moonset": "08:00"
      };

      final result = PanchangResult.fromJson(json);

      expect(result.tithi?.name, "Tithi 1");
      expect(result.vara?.name, "Sunday");
      expect(result.sunrise, "06:00");
      expect(result.sunset, "18:00");
    });

    test('fromJson handles missing sun/moon times gracefully', () {
      final json = <String, dynamic>{
        "tithi": {"name": "Tithi 1", "number": 1, "endTime": "10:00"},
        "vara": {"name": "Sunday", "number": 1},
        // Missing sunrise, sunset, etc.
      };

      final result = PanchangResult.fromJson(json);

      expect(result.tithi?.name, "Tithi 1");
      expect(result.sunrise, null);
      expect(result.sunset, null);
    });

    test('fromJson parses API response structure correctly', () {
      // This matches the structure we saw in the actual API response (Step 562)
      // Note: API response uses 'tithiName' inside 'tithi' object, etc.
      final json = <String, dynamic>{
        "tithi": {
          "tithiNumber": 17,
          "tithiName": "Tithi 17",
          "sanskritName": "Tithi 17",
          "startTime": "00:00",
          "endTime": "15:56",
          "shuklaPaksha": false
        },
        "vara": {
          "varaNumber": 7,
          "varaName": "Saturday",
          "sanskritName": "Saturday",
          "rulingPlanet": "Saturn"
        },
        // ... other fields
      };

      final result = PanchangResult.fromJson(json);

      expect(result.tithi?.name, "Tithi 17");
      expect(result.tithi?.number, 17);
      expect(result.vara?.name, "Saturday");
    });
  });
}
