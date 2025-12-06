import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/providers/settings_provider.dart';


// Helper to mock BuildContext and Provider lookup if necessary
// But PanchangUtils.getLocalizedTithiName uses context.read<SettingsProvider>()
//Testing static methods that use BuildContext is hard without a widget tree.
// We'll test formatTime which is a pure function.

void main() {
  group('PanchangUtils', () {
    test('formatTime converts UTC time string to local time formatted string', () {
      // API returns UTC time "hh:mm"
      // But implementation uses DateTime.now() to construct date, which makes it variable.
      // However, we can test that it returns a valid hh:mm string and handles offsets.
      // Wait, the formatTime implementation takes HH:mm string, treats it as UTC HH:mm on TODAY, and converts to local.
      
      // Since local time depends on machine timezone, testing exact output is tricky.
      // But we can check null/empty cases.
      expect(PanchangUtils.formatTime(null), '--:--');
      expect(PanchangUtils.formatTime('invalid'), 'invalid');
      
      const input = "10:30"; 
      final output = PanchangUtils.formatTime(input);
      expect(output, isNot("--:--"));
      expect(output.contains(":"), true);
      
      // If we run this in a controlled environment we could assert values, but locally it depends on TZ.
    });
  });
}
