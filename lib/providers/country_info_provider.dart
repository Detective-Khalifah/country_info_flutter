import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [Provider] for the API service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// [Future] provider for the list of countries
final countriesProvider = FutureProvider<List<Country>>((ref) async {
  ref.keepAlive(); // Keeps the fetched data alive across rebuilds and prevents infinite loop of API call?
  final apiService = ref.watch(apiServiceProvider);
  final filters = ref.watch(filtersProvider);
  return await apiService.fetchCountries(filters: filters);
});

final filtersProvider = StateProvider<Map<String, String?>>((ref) => {});
final selectedContinentProvider = StateProvider<String?>((ref) => "");
final selectedLanguageProvider = StateProvider<String?>((ref) => null);
final selectedTimezonesProvider = StateProvider<List<String>>((ref) => []);

final imageIndexProvider = StateProvider<int>((ref) => 0);
