import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/models/dasa_model.dart';

void main() {
  group('DasaResult', () {
    test('fromJson parses hierarchical JSON correctly', () {
      final json = <String, dynamic>{
        "planet": "Venus",
        "startDate": "2020-01-01T00:00:00",
        "endDate": "2040-01-01T00:00:00",
        "level": 1,
        "subPeriods": [
          {
            "planet": "Sun",
            "startDate": "2020-01-01T00:00:00",
            "endDate": "2021-01-01T00:00:00",
            "level": 2
          }
        ]
      };

      final result = DasaResult.fromJson(json);

      expect(result.planet, "Venus");
      expect(result.level, 1);
      expect(result.subPeriods?.length, 1);
      expect(result.subPeriods?.first.planet, "Sun");
      expect(result.subPeriods?.first.level, 2);
    });
  });
}
