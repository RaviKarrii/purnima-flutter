
class BirthDataInput {
  final String birthDateTime;
  final double latitude;
  final double longitude;
  final String placeName;
  final String? timeZone;

  BirthDataInput({
    required this.birthDateTime,
    required this.latitude,
    required this.longitude,
    required this.placeName,
    this.timeZone,
  });

  Map<String, dynamic> toJson() => {
    'birthDateTime': birthDateTime,
    'latitude': latitude,
    'longitude': longitude,
    'placeName': placeName,
    'timeZone': timeZone,
  };
}

class CompatibilityResult {
  final double? varnaKoota;
  final double? vashyaKoota;
  final double? taraKoota;
  final double? yoniKoota;
  final double? grahaMaitriKoota;
  final double? ganaKoota;
  final double? bhakootKoota;
  final double? nadiKoota;
  final double? totalScore;
  final double? maximumScore;
  final double? compatibilityPercentage;
  final String? compatibilityLevel;
  final String? overallAssessment;
  final String? detailedBreakdown;

  CompatibilityResult({
    this.varnaKoota,
    this.vashyaKoota,
    this.taraKoota,
    this.yoniKoota,
    this.grahaMaitriKoota,
    this.ganaKoota,
    this.bhakootKoota,
    this.nadiKoota,
    this.totalScore,
    this.maximumScore,
    this.compatibilityPercentage,
    this.compatibilityLevel,
    this.overallAssessment,
    this.detailedBreakdown,
  });

  factory CompatibilityResult.fromJson(Map<String, dynamic> json) {
    return CompatibilityResult(
      varnaKoota: (json['varnaKoota'] as num?)?.toDouble(),
      vashyaKoota: (json['vashyaKoota'] as num?)?.toDouble(),
      taraKoota: (json['taraKoota'] as num?)?.toDouble(),
      yoniKoota: (json['yoniKoota'] as num?)?.toDouble(),
      grahaMaitriKoota: (json['grahaMaitriKoota'] as num?)?.toDouble(),
      ganaKoota: (json['ganaKoota'] as num?)?.toDouble(),
      bhakootKoota: (json['bhakootKoota'] as num?)?.toDouble(),
      nadiKoota: (json['nadiKoota'] as num?)?.toDouble(),
      totalScore: (json['totalScore'] as num?)?.toDouble(),
      maximumScore: (json['maximumScore'] as num?)?.toDouble(),
      compatibilityPercentage: (json['compatibilityPercentage'] as num?)?.toDouble(),
      compatibilityLevel: json['compatibilityLevel'],
      overallAssessment: json['overallAssessment'],
      detailedBreakdown: json['detailedBreakdown'],
    );
  }
}
