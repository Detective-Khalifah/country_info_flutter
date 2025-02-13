import 'package:country_info_flutter/widgets/filters.dart';
import 'package:country_info_flutter/widgets/languages.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/providers/country_info_provider.dart';
import 'package:country_info_flutter/providers/theme.dart';
import 'package:country_info_flutter/screens/country_details_screen.dart';
import 'package:grouped_list/grouped_list.dart';

class CountriesListScreen extends ConsumerStatefulWidget {
  const CountriesListScreen({super.key});

  @override
  ConsumerState<CountriesListScreen> createState() =>
      _CountriesListScreenState();
}

class _CountriesListScreenState extends ConsumerState<CountriesListScreen> {
  late List<Country> allCountries = [];
  late List<Country> filteredCountries = [];

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Country>> theCountries = ref.watch(countriesProvider);
    final ThemeNotifier themeNotifier =
        ref.read(themeNotifierProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Explore",
            style: GoogleFonts.lilyScriptOne().copyWith(
              color: themeNotifier.isLightMode()
                  ? Color(0xFF001637)
                  : Color(0xFFEAECF0),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                themeNotifier.isLightMode()
                    ? Icons.wb_sunny_outlined
                    : Icons.brightness_3,
              ),
              onPressed: () {
                themeNotifier.switchTheme();
                if (kDebugMode) {
                  print("${Theme.of(context).brightness}");
                }
              },
            ),
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountryAutocompleteText(
                  allCountries: allCountries,
                  onFilter: (List<Country> newFilteredList) {
                    setState(() {
                      filteredCountries = newFilteredList;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.language,
                        color: themeNotifier.isLightMode()
                            ? Colors.black
                            : Colors.white,
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        builder: (context) => Languages(),
                      ),
                      label: Text(
                        "EN",
                        style: GoogleFonts.arimo(
                          color: themeNotifier.isLightMode()
                              ? Colors.black
                              : Color(0xFFD0D5DD),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        color: themeNotifier.isLightMode()
                            ? Colors.black
                            : Colors.white,
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        builder: (context) => Filters(),
                      ),
                      label: Text(
                        "Filter",
                        style: TextStyle(
                          color: themeNotifier.isLightMode()
                              ? Colors.black
                              : Color(0xFFD0D5DD),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: theCountries.when(
                    data: (countries) {
                      // If the countries haven't been loaded yet, store them
                      // if (allCountries.isEmpty) {
                      //   allCountries = countries;
                      //   filteredCountries = countries;
                      // }

                      // Always update the allCountries and filteredCountries lists
                      allCountries = countries;
                      // Initialize filteredCountries if it's empty or after data reload
                      if (filteredCountries.isEmpty) {
                        filteredCountries = List.from(allCountries);
                      }

                      // Sort the list of countries; not necessary when using order: [GroupedListOrder.ASC] if items' order is irrelevant
                      countries.sort((a, b) => a.name.compareTo(b.name));

                      return RefreshIndicator.adaptive(
                        onRefresh: () async {
                          // Invalidate the provider so that it fetches data again.
                          ref.invalidate(countriesProvider);
                          // Await the re-fetched data to complete.
                          await ref.read(countriesProvider.future);
                          // return ref.read(apiServiceProvider).fetchCountries();
                          await ref.read(apiServiceProvider).fetchCountries();

                          // Wait a moment for the provider to re-fetch before completing the refresh.
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: GroupedListView<Country, String>(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          elements: filteredCountries,
                          groupBy: (country) => country.name[0]
                              .toUpperCase(), // Group by first letter
                          groupSeparatorBuilder: (String letter) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeNotifier.isLightMode()
                                    ? Color(0xFF667085)
                                    : Color(0xFF98A2B3),
                              ),
                            ),
                          ),
                          itemBuilder: (BuildContext context, Country country) {
                            return ListTile(
                              leading: Text(
                                country.flagmoji,
                                style: TextStyle(fontSize: 40),
                              ),
                              title: Text(
                                country.name,
                              ),
                              subtitle: Text(
                                country.capitalCity,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CountryDetailsScreen(country: country),
                                  ),
                                );
                              },
                            );
                          },
                          // Sort the groups in ascending order
                          order: GroupedListOrder.ASC,
                        ),
                      );
                    },
                    error: (error, StackTrace stackTrace) {
                      if (kDebugMode) {
                        print("Stack trace: $stackTrace");
                      }
                      return RefreshIndicator.adaptive(
                        displacement: 0.5,
                        onRefresh: () {
                          // Invalidate the provider so that it fetches data again.
                          ref.invalidate(countriesProvider);
                          // Await the re-fetched data to complete.
                          // await ref.read(countriesProvider.future);
                          // return ref.read(apiServiceProvider).fetchCountries();
                          return ref.watch(apiServiceProvider).fetchCountries();

                          // Wait a moment for the provider to re-fetch before completing the refresh.
                          // await Future.delayed(const Duration(seconds: 1));
                        },
                        child: SizedBox(
                          height: 800,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  '$error occurred',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () {
                      return Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Color(0xFF000F24),
                          semanticsLabel: "Loading countries",
                          strokeWidth: 8,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class CountryAutocompleteText extends StatefulWidget {
  final List<Country> allCountries;
  final ValueChanged<List<Country>>
      onFilter; // Callback to update filtered list

  const CountryAutocompleteText({
    super.key,
    required this.allCountries,
    required this.onFilter,
  });

  @override
  State<CountryAutocompleteText> createState() =>
      _CountryAutocompleteTextState();
}

class _CountryAutocompleteTextState extends State<CountryAutocompleteText> {
  late TextEditingController _countriesAutocompleteController;
  late FocusNode _focusNode;

  late Country? _selectedCountry;
  late List<Country> countries = [];

  /// Listen to text changes, filter the list
  void _filterCountries() {
    final query = _countriesAutocompleteController.text.trim().toLowerCase();
    if (query.isEmpty) {
      // Return the full list if there's no query
      widget.onFilter(widget.allCountries);
    } else {
      // Filter the list based on typed text
      final filtered = widget.allCountries.where((country) {
        return country.name.toLowerCase().contains(query);
      }).toList();
      widget.onFilter(filtered);
    }
  }

  @override
  void initState() {
    super.initState();
    // _countriesAutocompleteController = TextEditingController();
    _focusNode = FocusNode();

    // _countriesAutocompleteController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _countriesAutocompleteController.removeListener(_filterCountries);
    // No need to dispose of _countriesAutocompleteController and _focusNode here,
    // because they are provided by the Autocomplete widget.
    // _countriesAutocompleteController.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Autocomplete<Country>(
        displayStringForOption: (Country theCountry) => theCountry.name,
        // Return an empty list so the default overlay never shows
        optionsBuilder: (TextEditingValue textEditingValue) =>
            const Iterable.empty(),
        // Provide an empty container for the overlay
        optionsViewBuilder: (context, onSelected, options) =>
            const SizedBox.shrink(),
        onSelected: (suggestion) {
          setState(() {
            _selectedCountry = suggestion;
            if (_selectedCountry != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CountryDetailsScreen(country: _selectedCountry!),
                ),
              );
            }
          });
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          _countriesAutocompleteController = controller;
          _focusNode = focusNode;

          _countriesAutocompleteController.addListener(_filterCountries);

          return TextFormField(
            controller: _countriesAutocompleteController,
            enableSuggestions: true,
            focusNode: _focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Color(0x3398A2B3)
                  : Color(0xFFF2F4F7),
              border: OutlineInputBorder(),
              // labelText: "Search Country",
              // labelStyle: TextStyle(textAlign: TextAlign.center),
              label: Center(
                child: Text(
                  "Search Country",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Color(0xFF98A2B3)
                        : Color(0xFFF2F4F7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              prefixIcon: Icon(Icons.search),
              hintText: "Enter a country name",
              suffixIcon: _countriesAutocompleteController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(
                            () => _countriesAutocompleteController.clear());
                      },
                    )
                  : null,
            ),
            validator: (String? value) {
              final matchingCountries = countries.where((aState) =>
                  aState.name.toLowerCase() == value?.toLowerCase());

              if (matchingCountries.length == 1 &&
                  countries.elementAt(0) == matchingCountries.first) {
                _selectedCountry = matchingCountries.first;
                return null;
              }

              // Keep this here to avoid validation getting triggered when form loads, until the user interacts with the field
              if (value == null || value.isEmpty || matchingCountries.isEmpty) {
                return 'Please select a country';
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
