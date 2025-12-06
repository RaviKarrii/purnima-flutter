class PanchangResult {
  final PanchangElement? tithi;
  final PanchangElement? vara;
  final PanchangElement? nakshatra;
  final PanchangElement? yoga;
  final PanchangElement? karana;
  final String? sunrise;
  final String? sunset;
  final String? moonrise;
  final String? moonset;

  final String? dateTime;
  final String? placeName;
  final double? latitude;
  final double? longitude;

  PanchangResult({
    this.tithi,
    this.vara,
    this.nakshatra,
    this.yoga,
    this.karana,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.dateTime,
    this.placeName,
    this.latitude,
    this.longitude,
  });

  factory PanchangResult.fromJson(Map<String, dynamic> json) {
    return PanchangResult(
      tithi: json['tithi'] != null ? PanchangElement.fromJson(json['tithi'], 'tithiName') : null,
      vara: json['vara'] != null ? PanchangElement.fromJson(json['vara'], 'varaName') : null,
      nakshatra: json['nakshatra'] != null ? PanchangElement.fromJson(json['nakshatra'], 'nakshatraName') : null,
      yoga: json['yoga'] != null ? PanchangElement.fromJson(json['yoga'], 'yogaName') : null,
      karana: json['karana'] != null ? PanchangElement.fromJson(json['karana'], 'karanaName') : null,
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      dateTime: json['dateTime'],
      placeName: json['placeName'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}

class PanchangElement {
  final String? name;
  final int? number;
  final String? endTime;

  PanchangElement({this.name, this.number, this.endTime});

  factory PanchangElement.fromJson(Map<String, dynamic> json, String nameKey) {
    return PanchangElement(
      name: json[nameKey] ?? json['name'],
      number: json['number'] ?? json['${nameKey.replaceAll("Name", "")}Number'],
      endTime: json['endTime'],
    );
  }
}
