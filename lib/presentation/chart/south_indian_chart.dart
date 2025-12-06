import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/chart_model.dart';

class SouthIndianChart extends StatelessWidget {
  final List<PlanetInfo> planets;
  final HouseInfo ascendant;

  const SouthIndianChart({
    super.key,
    required this.planets,
    required this.ascendant,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _SouthIndianChartPainter(
          context: context,
          planets: planets,
          ascendant: ascendant,
        ),
      ),
    );
  }
}

class _SouthIndianChartPainter extends CustomPainter {
  final BuildContext context;
  final List<PlanetInfo> planets;
  final HouseInfo ascendant;

  _SouthIndianChartPainter({
    required this.context,
    required this.planets,
    required this.ascendant,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;
    final cellW = width / 4;
    final cellH = height / 4;

    // Draw outer box
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Draw inner lines
    // Vertical lines
    canvas.drawLine(Offset(cellW, 0), Offset(cellW, height), paint);
    canvas.drawLine(Offset(cellW * 2, 0), Offset(cellW * 2, cellH), paint); // Top middle
    canvas.drawLine(Offset(cellW * 2, cellH * 3), Offset(cellW * 2, height), paint); // Bottom middle
    canvas.drawLine(Offset(cellW * 3, 0), Offset(cellW * 3, height), paint);

    // Horizontal lines
    canvas.drawLine(Offset(0, cellH), Offset(width, cellH), paint);
    canvas.drawLine(Offset(0, cellH * 2), Offset(cellW, cellH * 2), paint); // Left middle
    canvas.drawLine(Offset(cellW * 3, cellH * 2), Offset(width, cellH * 2), paint); // Right middle
    canvas.drawLine(Offset(0, cellH * 3), Offset(width, cellH * 3), paint);

    // Cross in the center (optional, but common in some styles, usually empty)
    // We leave the center empty as per standard South Indian style

    // Draw Planets
    _drawPlanets(canvas, size, cellW, cellH);
  }

  void _drawPlanets(Canvas canvas, Size size, double cellW, double cellH) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Map Rashi names to grid positions (row, col)
    // Pisces(12) Aries(1) Taurus(2) Gemini(3)
    // Aquarius(11)                 Cancer(4)
    // Capricorn(10)                Leo(5)
    // Sagittarius(9) Scorpio(8) Libra(7) Virgo(6)
    
    // Map Rashi codes (from API enum) to grid positions (row, col)
    // 0,0 is Top-Left.
    // MEEN(12) MESH(1) VRISHABH(2) MITHUN(3)
    // KUMBH(11)                    KARK(4)
    // MAKAR(10)                    SIMHA(5)
    // DHANU(9) VRISHCHIK(8) TULA(7) KANYA(6)
    
    final rashiMap = {
      'MEEN': const Offset(0, 0),      // Pisces
      'MESH': const Offset(1, 0),      // Aries
      'VRISHABH': const Offset(2, 0),  // Taurus
      'MITHUN': const Offset(3, 0),    // Gemini
      'KARK': const Offset(3, 1),      // Cancer
      'SIMHA': const Offset(3, 2),     // Leo
      'KANYA': const Offset(3, 3),     // Virgo
      'TULA': const Offset(2, 3),      // Libra
      'VRISHCHIK': const Offset(1, 3), // Scorpio
      'DHANU': const Offset(0, 3),     // Sagittarius
      'MAKAR': const Offset(0, 2),     // Capricorn
      'KUMBH': const Offset(0, 1),     // Aquarius
    };

    // Draw Ascendant (Lagna)
    if (ascendant.rashi != null && rashiMap.containsKey(ascendant.rashi)) {
      final pos = rashiMap[ascendant.rashi]!;
      final x = pos.dx * cellW + cellW / 2;
      final y = pos.dy * cellH + cellH / 2;
      
      textPainter.text = TextSpan(
        text: 'L', // Lagna
        style: GoogleFonts.notoSans(
          textStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Group planets by Rashi to avoid overlap
    final planetsByRashi = <String, List<PlanetInfo>>{};
    for (var planet in planets) {
      if (planet.rashi != null) {
        planetsByRashi.putIfAbsent(planet.rashi!, () => []).add(planet);
      }
    }

    // Draw Planets
    planetsByRashi.forEach((rashi, planetList) {
      if (rashiMap.containsKey(rashi)) {
        final pos = rashiMap[rashi]!;
        final centerX = pos.dx * cellW + cellW / 2;
        final centerY = pos.dy * cellH + cellH / 2;

        // If Lagna is also in this rashi, shift planets slightly
        double yOffset = (ascendant.rashi == rashi) ? 10 : -((planetList.length - 1) * 8.0);

        for (var planet in planetList) {
          // Use localized planet name if available, or fallback to first 2 chars of English name
          // Since we don't have easy access to localized short codes here without context, 
          // we might want to use a mapping or just first 2 chars of the name returned by API.
          // However, API returns full localized name in 'planetName'.
          // Let's try to use a short version.
          
          String displayName = planet.planetName?.substring(0, 2) ?? '??';
          
          // Better approach: Map standard planet codes to short forms if possible, 
          // or just use the first 2 letters of the localized name.
          
          textPainter.text = TextSpan(
            text: displayName,
            style: GoogleFonts.notoSans(
              textStyle: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
          textPainter.layout();
          textPainter.paint(canvas, Offset(centerX - textPainter.width / 2, centerY + yOffset));
          yOffset += 16;
        }
      }
    });
  }

  String _getShortName(String name) {
    switch (name.toLowerCase()) {
      case 'sun': return 'Su';
      case 'moon': return 'Mo';
      case 'mars': return 'Ma';
      case 'mercury': return 'Me';
      case 'jupiter': return 'Ju';
      case 'venus': return 'Ve';
      case 'saturn': return 'Sa';
      case 'rahu': return 'Ra';
      case 'ketu': return 'Ke';
      default: return name.substring(0, 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
