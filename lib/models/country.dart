import 'package:country_info_flutter/models/president.dart';

class Country {
  final String name;
  final String officialName;
  final List<String>? states;
  final int population;
  final String capitalCity;
  final President? president;
  final List<Continent>? continents;
  final String countryCode;
  final Maps? maps;
  final CoatOfArms? coatOfArms;
  final Map<String, String>? languages;
  final Map<String, Currency>? currencies;
  final List<String> timezones;
  final String flagmoji; // flag emoji
  final Flags? flags;

  Country({
    required this.name,
    required this.flagmoji,
    required this.countryCode,
    required this.officialName,
    this.states,
    required this.population,
    required this.capitalCity,
    this.president,
    required this.continents,
    required this.maps,
    required this.coatOfArms,
    required this.flags,
    this.languages,
    this.currencies,
    required this.timezones,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json["name"]["common"] as String,
      flagmoji: json["flag"] as String,
      officialName: json["name"]["official"] as String,
      countryCode: json["cca3"] as String,
      capitalCity: json["capital"] == null
          ? ''
          // : List<String>.from(json["capital"]!.map((x) => x)),
          // : (json["capital"]!.map((x) => x) as List<String>).first,
          : List<String>.from(json["capital"]!.map((x) => x)).first,
      // ? '' : (json["capital"] as List).isNotEmpty ? json["capital"][0] : '',
      continents: List<Continent>.from(
          json["continents"].map((x) => continentValues.map[x]!)),
      flags: Flags.fromJson(json["flags"]), // links
      coatOfArms: CoatOfArms.fromJson(json["coatOfArms"]), // coat of arms
      maps: Maps.fromMap(json["maps"]),
      population: json["population"] as int,
      languages: json["languages"] != null
          ? Map.from(json["languages"])
              .map((k, v) => MapEntry<String, String>(k, v))
          : {},
      currencies: json["currencies"] != null
          ? Map.from(json["currencies"]).map(
              (k, v) => MapEntry<String, Currency>(k, Currency.fromJson(v)))
          : {},
      timezones: List<String>.from(json["timezones"].map((x) => x)),
    );
  }
}

class MinCountry {
  final String name;
  final String capitalCity;
  final String flagmoji;

  MinCountry({
    required this.name,
    required this.flagmoji,
    required this.capitalCity,
  });

  factory MinCountry.fromJson(Map<String, dynamic> json) {
    return MinCountry(
      name: json["common"],
      flagmoji: json["flag"],
      capitalCity: json["capital"] == null
          ? ''
          // : List<String>.from(json["capital"]!.map((x) => x)),
          // : (json["capital"]!.map((x) => x) as List<String>).first,
          : List<String>.from(json["capital"]!.map((x) => x)).first,
      // ? '' : (json["capital"] as List).isNotEmpty ? json["capital"][0] : '',
    );
  }
}

class CoatOfArms {
  final String? png;
  final String? svg;

  CoatOfArms({
    this.png,
    this.svg,
  });

  CoatOfArms copyWith({
    String? png,
    String? svg,
  }) =>
      CoatOfArms(
        png: png ?? this.png,
        svg: svg ?? this.svg,
      );

  factory CoatOfArms.fromJson(Map<String, dynamic> json) => CoatOfArms(
        png: json["png"],
        svg: json["svg"],
      );

  Map<String, dynamic> toJson() => {
        "png": png,
        "svg": svg,
      };
}

class Flags {
  final String png;
  final String svg;
  final String? alt;

  Flags({
    required this.png,
    required this.svg,
    this.alt,
  });

  Flags copyWith({
    String? png,
    String? svg,
    String? alt,
  }) =>
      Flags(
        png: png ?? this.png,
        svg: svg ?? this.svg,
        alt: alt ?? this.alt,
      );

  factory Flags.fromJson(Map<String, dynamic> json) => Flags(
        png: json["png"],
        svg: json["svg"],
        alt: json["alt"],
      );

  Map<String, dynamic> toJson() => {
        "png": png,
        "svg": svg,
        "alt": alt,
      };
}

class Maps {
  final String googleMaps;
  final String openStreetMaps;

  Maps({
    required this.googleMaps,
    required this.openStreetMaps,
  });

  Maps copyWith({
    String? googleMaps,
    String? openStreetMaps,
  }) =>
      Maps(
        googleMaps: googleMaps ?? this.googleMaps,
        openStreetMaps: openStreetMaps ?? this.openStreetMaps,
      );

  factory Maps.fromMap(Map<String, dynamic> json) => Maps(
        googleMaps: json["googleMaps"],
        openStreetMaps: json["openStreetMaps"],
      );

  Map<String, dynamic> toJson() => {
        "googleMaps": googleMaps,
        "openStreetMaps": openStreetMaps,
      };
}

enum Continent {
  AFRICA,
  ANTARCTICA,
  ASIA,
  EUROPE,
  NORTH_AMERICA,
  OCEANIA,
  SOUTH_AMERICA
}

final continentValues = EnumValues({
  "Africa": Continent.AFRICA,
  "Antarctica": Continent.ANTARCTICA,
  "Asia": Continent.ASIA,
  "Europe": Continent.EUROPE,
  "North America": Continent.NORTH_AMERICA,
  "Oceania": Continent.OCEANIA,
  "South America": Continent.SOUTH_AMERICA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Currency {
  final String name;
  final String symbol;

  Currency({
    required this.name,
    required this.symbol,
  });

  Currency copyWith({
    String? name,
    String? symbol,
  }) =>
      Currency(
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
      );

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        name: json["name"],
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
      };
}
