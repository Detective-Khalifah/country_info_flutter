import 'dart:convert';
import 'package:country_info_flutter/models/country.dart';
import 'package:http/http.dart' as webber;

class ApiService {
  final String baseUrl = 'https://restcountries.com/v3.1/all';

  Future<List<Country>> fetchCountries() async {
    final url = Uri.parse(baseUrl);
    final response = await webber.get(url);
    print(
        "Status code: ${response.statusCode}\tHeaders${response.headers}.\nResponse: ${response.body}.");

    if (response.statusCode == 200) {
      final /*List<dynamic>*/ jsonData =
          (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      print("jsonData: $jsonData");
      return jsonData.map<Country>((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
