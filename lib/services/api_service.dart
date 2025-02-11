import 'dart:convert';
import 'package:country_info_flutter/models/country.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:http/http.dart' as webber;

class ApiService {
  final String baseUrl = 'https://restcountries.com/v3.1';

  Future<List<Country>> fetchCountries({Map<String, String?>? filters}) async {
    String endpoint = "/all"; // Default to all countries
    // if (filters?["lang"] != null && filters?["region"] != null) {
    //   endpoint = "/all?lang=${filters?["lang"]}&region=${filters?["region"]}";
    // }
    if (filters?["lang"] != null) {
      if (kDebugMode) {
        print("Language: ${filters?["lang"]}");
      }
      endpoint = "/lang/${filters?["lang"]}";
    } else if (filters?["region"] != null) {
      if (kDebugMode) {
        print("Regions: ${filters?["region"]}");
      }
      endpoint = "/region/${filters?["region"]}";
    }

    if (kDebugMode) {
      print("Endpoint: $endpoint");
    }

    final url = Uri.parse("$baseUrl$endpoint");
    if (kDebugMode) {
      print("url: $url");
    }
    final response = await webber.get(url);
    if (kDebugMode) {
      print(
          "Status code: ${response.statusCode}\tHeaders${response.headers}.\nResponse: ${response.body}.");
    }

    if (response.statusCode == 200) {
      final /*List<dynamic>*/ jsonData =
          (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      if (kDebugMode) {
        print("jsonData: $jsonData");
      }
      return jsonData.map<Country>((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
