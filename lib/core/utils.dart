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
      DateTime dateTime;
      if (timeStr.contains('T')) {
          dateTime = DateTime.parse(timeStr).toLocal();
      } else {
        // Assume HH:mm string (UTC) if no date part
        final parts = timeStr.split(':');
        if (parts.length < 2) return timeStr;
        
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        
        final now = DateTime.now().toUtc();
        final utcTime = DateTime.utc(now.year, now.month, now.day, hour, minute);
        dateTime = utcTime.toLocal();
      }
      
      // Format to HH:mm
      final localHour = dateTime.hour.toString().padLeft(2, '0');
      final localMinute = dateTime.minute.toString().padLeft(2, '0');
      return "$localHour:$localMinute";
    } catch (e) {
      return timeStr;
    }
  }
}
