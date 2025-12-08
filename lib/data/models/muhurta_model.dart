class MuhurtaResult {
  final List<Choghadiya>? dayChoghadiya;
  final List<Choghadiya>? nightChoghadiya;
  final List<Hora>? dayHora;
  final List<Hora>? nightHora;
  final TimeSpan? rahuKalam;
  final TimeSpan? yamagandam;
  final TimeSpan? gulikaKalam;

  MuhurtaResult({
    this.dayChoghadiya,
    this.nightChoghadiya,
    this.dayHora,
    this.nightHora,
    this.rahuKalam,
    this.yamagandam,
    this.gulikaKalam,
  });

  factory MuhurtaResult.fromJson(Map<String, dynamic> json) {
    return MuhurtaResult(
      dayChoghadiya: json['dayChoghadiya'] != null
          ? (json['dayChoghadiya'] as List)
              .map((e) => Choghadiya.fromJson(e))
              .toList()
          : null,
      nightChoghadiya: json['nightChoghadiya'] != null
          ? (json['nightChoghadiya'] as List)
              .map((e) => Choghadiya.fromJson(e))
              .toList()
          : null,
      dayHora: (json['horas'] as List?) // Mapping top-level 'horas' to dayHora for now, assuming day/night split logic logic or just flattening.
          ?.map((e) => Hora.fromJson(e))
          .toList(), 
      // Note: The API response shows a single list 'horas'. Our model expects split day/night.
      // For now, let's just use the single list 'horas' for dayHora and leave nightHora empty or split logic required.
      // Better: Map 'horas' to 'dayHora' and ignore 'nightHora' for now to show something, or split if times indicate.
      // Based on API response, 'horas' contains 24 items, covering full day.
      // Let's populate 'dayHora' with all of them for now so they appear.
      
      nightHora: null, 

      rahuKalam: json['inauspiciousTimes']?['rahuKalam'] != null
          ? TimeSpan.fromJson(json['inauspiciousTimes']['rahuKalam'])
          : null,
      yamagandam: json['inauspiciousTimes']?['yamagandam'] != null
          ? TimeSpan.fromJson(json['inauspiciousTimes']['yamagandam'])
          : null,
      gulikaKalam: json['inauspiciousTimes']?['gulikaKalam'] != null
          ? TimeSpan.fromJson(json['inauspiciousTimes']['gulikaKalam'])
          : null,
    );
  }
}

class Choghadiya {
  final String? name;
  final String? nature;
  final String? startTime;
  final String? endTime;
  final String? color;

  Choghadiya({this.name, this.nature, this.startTime, this.endTime, this.color});

  factory Choghadiya.fromJson(Map<String, dynamic> json) {
    return Choghadiya(
      name: json['name'],
      nature: json['nature'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      color: json['color'],
    );
  }
}

class Hora {
  final String? planet;
  final String? startTime;
  final String? endTime;

  Hora({this.planet, this.startTime, this.endTime});

  factory Hora.fromJson(Map<String, dynamic> json) {
    return Hora(
      planet: json['planet'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

class TimeSpan {
  final String? startTime;
  final String? endTime;

  TimeSpan({this.startTime, this.endTime});

  factory TimeSpan.fromJson(Map<String, dynamic> json) {
    return TimeSpan(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

class MuhurtaSlot {
  final String? startTime;
  final String? endTime;
  final String? quality;
  final List<String>? positiveFactors;
  final List<String>? negativeFactors;
  final String? color;

  MuhurtaSlot({
    this.startTime,
    this.endTime,
    this.quality,
    this.positiveFactors,
    this.negativeFactors,
    this.color,
  });

  factory MuhurtaSlot.fromJson(Map<String, dynamic> json) {
    return MuhurtaSlot(
      startTime: json['startTime'],
      endTime: json['endTime'],
      quality: json['quality'],
      positiveFactors: json['positiveFactors'] != null
          ? List<String>.from(json['positiveFactors'])
          : null,
      negativeFactors: json['negativeFactors'] != null
          ? List<String>.from(json['negativeFactors'])
          : null,
      color: json['color'],
    );
  }
}
