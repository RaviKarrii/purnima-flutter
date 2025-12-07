import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/settings_provider.dart';

class PanchangUtils {
  static String getLocalizedTithiName(BuildContext context, int number) {
    final settings = context.read<SettingsProvider>();
    
    if (number >= 1 && number <= 15) {
      // Shukla Paksha
      final tithiName = settings.getString('tithi_$number');
      return "${settings.getString('shukla')} $tithiName";
    } else if (number >= 16 && number <= 30) {
      // Krishna Paksha
      final adjustedNumber = number - 15;
      // Special case for Amavasya (30)
      if (number == 30) {
         return settings.getString('tithi_30');
      }
      final tithiName = settings.getString('tithi_$adjustedNumber');
      return "${settings.getString('krishna')} $tithiName";
    }
    return "Tithi $number";
  }

  static String formatTime(String? timeStr) {
    if (timeStr == null) return '--:--';
    try {
      // Check if it's an ISO 8601 string (contains 'T')
      if (timeStr.contains('T')) {
          // Extract HH:mm directly from string to ensure absolutely no timezone conversion or shifting happens
          // Format is usually YYYY-MM-DDTHH:mm:ss
          final timePart = timeStr.split('T')[1];
          if (timePart.length >= 5) {
            return timePart.substring(0, 5);
          }
          return timePart;
      } else {
        // Assume HH:mm string. 
        return timeStr;
      }
    } catch (e) {
      return timeStr;
    }
  }
}
