class Country {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final double area;
  final String flag;
  final String currency;
  final String language;

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.area,
    required this.flag,
    required this.currency,
    required this.language,
  });

  factory Country.fromJson(Map<String, dynamic> json) {

    final nameObj = json['name'];
    String commonName = 'Unknown';
    String officialName = 'Unknown';

    if (nameObj is Map) {
      commonName = nameObj['common'] ?? 'Unknown';
      officialName = nameObj['official'] ?? 'Unknown';
    } else if (nameObj is String) {
      commonName = nameObj;
      officialName = json['officialName'] ?? 'Unknown';
    }

    String capital = 'No capital';
    if (json['capital'] is List && (json['capital'] as List).isNotEmpty) {
      capital = json['capital'][0];
    } else if (json['capital'] is String) {
      capital = json['capital'];
    }

    final region = json['region'] ?? 'Unknown';
    final subregion = json['subregion'] ?? 'Unknown';
    final population = json['population'] ?? 0;
    final area = (json['area'] ?? 0).toDouble();
    final flag = json['flag'] ?? '🏳️';

    String currency = 'Unknown';
    final currencies = json['currencies'];
    if (currencies is Map && currencies.isNotEmpty) {
      final first = currencies.values.first;
      if (first is Map) {
        currency = first['name'] ?? 'Unknown';
      }
    } else if (json['currency'] is String) {
      currency = json['currency'];
    }

    String language = 'Unknown';
    final languages = json['languages'];
    if (languages is Map && languages.isNotEmpty) {
      language = languages.values.first.toString();
    } else if (json['language'] is String) {
      language = json['language'];
    }

    return Country(
      name: commonName,
      officialName: officialName,
      capital: capital,
      region: region,
      subregion: subregion,
      population: population,
      area: area,
      flag: flag,
      currency: currency,
      language: language,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'officialName': officialName,
    'capital': capital,
    'region': region,
    'subregion': subregion,
    'population': population,
    'area': area,
    'flag': flag,
    'currency': currency,
    'language': language,
  };
}