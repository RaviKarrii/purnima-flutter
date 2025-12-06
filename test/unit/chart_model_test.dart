import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/models/chart_model.dart';

void main() {
  group('ChartResult', () {
    test('fromJson parses complete JSON correctly', () {
      final json = <String, dynamic>{
        "birthData": {
          "birthDateTime": "2000-01-01T12:00:00",
          "latitude": 17.385,
          "longitude": 78.4867,
          "placeName": "Hyderabad",
          "timeZone": "Asia/Kolkata"
        },
        "planetaryPositions": [
          {
            "planet": "SUN",
            "planetName": "Sun",
            "rashi": "DHANU",
            "rashiName": "Sagittarius",
            "degreeInRashi": 15.63,
            "houseNumber": 7,
            "retrograde": false
          }
        ],
        "ascendant": {
          "rashi": "MESH",
          "rashiName": "Aries",
          "houseNumber": 1
        }
      };

      final result = ChartResult.fromJson(json);

      expect(result.ascendant?.rashi, "MESH");
      expect(result.ascendant?.rashiName, "Aries");
      expect(result.planetaryPositions?.length, 1);
      expect(result.planetaryPositions?.first.planetName, "Sun");
      expect(result.planetaryPositions?.first.rashi, "DHANU");
      expect(result.planetaryPositions?.first.degreeInRashi, 15.63);
    });

    test('fromJson handles nulls gracefully', () {
      final json = <String, dynamic>{};
      final result = ChartResult.fromJson(json);
      expect(result.ascendant, null);
      expect(result.planetaryPositions, null);
    });
  });
}
