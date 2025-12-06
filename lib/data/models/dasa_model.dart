class DasaResult {
  final String? planet;
  final String? startDate;
  final String? endDate;
  final int? level;
  final List<DasaResult>? subPeriods;

  DasaResult({
    this.planet,
    this.startDate,
    this.endDate,
    this.level,
    this.subPeriods,
  });

  factory DasaResult.fromJson(Map<String, dynamic> json) {
    // Check for either 'subPeriods' or 'subDasas'
    final subItems = json['subPeriods'] ?? json['subDasas'];
    
    return DasaResult(
      planet: json['planet'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      level: json['level'],
      subPeriods: subItems != null
          ? (subItems as List)
              .map((e) => DasaResult.fromJson(e))
              .toList()
          : null,
    );
  }
}
