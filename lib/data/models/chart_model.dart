class ChartResult {
  final HouseInfo? ascendant;
  final List<PlanetInfo>? planetaryPositions;
  final List<HouseInfo>? houses;

  ChartResult({this.ascendant, this.planetaryPositions, this.houses});

  factory ChartResult.fromJson(Map<String, dynamic> json) {
    return ChartResult(
      ascendant: json['ascendant'] != null ? HouseInfo.fromJson(json['ascendant']) : null,
      planetaryPositions: json['planetaryPositions'] != null
          ? (json['planetaryPositions'] as List)
              .map((e) => PlanetInfo.fromJson(e))
              .toList()
          : null,
      houses: json['houses'] != null
          ? (json['houses'] as List).map((e) => HouseInfo.fromJson(e)).toList()
          : null,
    );
  }
}

class PlanetInfo {
  final String? planetName;
  final double? degreeInRashi;
  final String? rashi; // Stable identifier (e.g., MESH, VRISHABH)
  final String? rashiName;
  final bool? retrograde;
  final int? houseNumber;

  PlanetInfo({
    this.planetName,
    this.degreeInRashi,
    this.rashi,
    this.rashiName,
    this.retrograde,
    this.houseNumber,
  });

  factory PlanetInfo.fromJson(Map<String, dynamic> json) {
    return PlanetInfo(
      planetName: json['planetName'],
      degreeInRashi: (json['degreeInRashi'] as num?)?.toDouble(),
      rashi: json['rashi'],
      rashiName: json['rashiName'],
      retrograde: json['retrograde'],
      houseNumber: json['houseNumber'],
    );
  }
}

class HouseInfo {
  final int? houseNumber;
  final String? rashi;
  final String? rashiName;
  final double? startDegree;
  final double? endDegree;

  HouseInfo({
    this.houseNumber,
    this.rashi,
    this.rashiName,
    this.startDegree,
    this.endDegree,
  });

  factory HouseInfo.fromJson(Map<String, dynamic> json) {
    return HouseInfo(
      houseNumber: json['houseNumber'],
      rashi: json['rashi'],
      rashiName: json['rashiName'],
      startDegree: (json['startDegree'] as num?)?.toDouble(),
      endDegree: (json['endDegree'] as num?)?.toDouble(),
    );
  }
}
