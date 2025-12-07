import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/models/muhurta_model.dart';

void main() {
  group('MuhurtaResult', () {
    test('fromJson parses complex JSON correctly', () {
      final json = <String, dynamic>{
        "dayChoghadiya": [
          {
            "name": "Udveg",
            "nature": "BAD",
            "startTime": "06:00",
            "endTime": "07:30"
          }
        ],
        "inauspiciousTimes": {
          "rahuKalam": {
            "startTime": "16:30",
            "endTime": "18:00"
          }
        }
      };

      final result = MuhurtaResult.fromJson(json);

      expect(result.dayChoghadiya?.length, 1);
      expect(result.dayChoghadiya?.first.name, "Udveg");
      expect(result.dayChoghadiya?.first.nature, "BAD");
      expect(result.rahuKalam?.startTime, "16:30");
      expect(result.rahuKalam?.endTime, "18:00");
    });
  });
}
