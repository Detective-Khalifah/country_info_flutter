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

class CountriesListScreen extends ConsumerStatefulWidget {
  const CountriesListScreen({super.key});

  @override
  ConsumerState<CountriesListScreen> createState() =>
      _CountriesListScreenState();
}

class _CountriesListScreenState extends ConsumerState<CountriesListScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Country>> theCountries = ref.watch(countriesProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Countries"),
          actions: [
            IconButton(
              icon: Icon(
                themeNotifier.isLightMode()
                    ? Icons.brightness_7
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountryAutocompleteText(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.language),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Languages(),
                        );
                      },
                      label: Text(
                        "EN",
                        style: GoogleFonts.arimo(
                          color: themeNotifier.isLightMode()
                              ? Color(0xFFD0D5DD)
                              : Colors.white,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.filter),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => Filters(),
                      ),
                      label: Text(
                        "Filter",
                        style: GoogleFonts.arimo(
                          color: themeNotifier.isLightMode()
                              ? Color(0xFFD0D5DD)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                theCountries.when(
                  data: (countries) {
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        // itemCount: theCountries.asData?.value.length,
                        itemCount: countries.length,
                        itemBuilder: (BuildContext context, int index) {
                          final country = countries[index];
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
  const CountryAutocompleteText({super.key});

  @override
  State<CountryAutocompleteText> createState() =>
      _CountryAutocompleteTextState();
}

class _CountryAutocompleteTextState extends State<CountryAutocompleteText> {
  late TextEditingController countriesAutocompleteController =
      TextEditingController();

  late Country? _selectedCountry;
  late List<Country> countries = [];

  @override
  void dispose() {
    countriesAutocompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Country>(
      displayStringForOption: (Country theCountry) {
        return theCountry.name;
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return [];
          // TODO: show loading indicator?
        }
        return countries.where((aCountry) => aCountry.name
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
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
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        countriesAutocompleteController = controller;
        return TextFormField(
          controller: countriesAutocompleteController,
          enableSuggestions: false,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Country",
            hintText: "Enter a country name",
            suffixIcon: countriesAutocompleteController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() => countriesAutocompleteController.clear());
                    },
                  )
                : null,
          ),
          validator: (String? value) {
            // If the hit is not an exact match, clear lga field and show error text
            final matchingCountries = countries.where(
                (aState) => aState.name.toLowerCase() == value?.toLowerCase());

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
    );
  }
}
