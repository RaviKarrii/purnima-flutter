class PanchangResult {
  final List<PanchangElement>? tithi;
  final PanchangElement? vara;
  final List<PanchangElement>? nakshatra;
  final List<PanchangElement>? yoga;
  final List<PanchangElement>? karana;
  final String? sunrise;
  final String? sunset;
  final String? moonrise;
  final String? moonset;

  final String? dateTime;
  final String? placeName;
  final double? latitude;
  final double? longitude;

  String? get tithiString => tithi?.map((e) => e.name).join(', ');

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
    List<PanchangElement>? parseList(dynamic data, String nameKey) {
      if (data == null) return null;
      if (data is List) {
        return data.map((e) => PanchangElement.fromJson(e, nameKey)).toList();
      }
      return null;
    }

    return PanchangResult(
      tithi: parseList(json['tithi'], 'tithiName'),
      vara: json['vara'] != null ? PanchangElement.fromJson(json['vara'], 'varaName') : null,
      nakshatra: parseList(json['nakshatra'], 'nakshatraName'),
      yoga: parseList(json['yoga'], 'yogaName'),
      karana: parseList(json['karana'], 'karanaName'),
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
