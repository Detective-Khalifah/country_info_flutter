import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/screens/country_details_screen.dart';
import 'package:flutter/material.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  late TextEditingController countriesAutocompleteController =
      TextEditingController();

  late Country? _selectedCountry;
  late List<Country> countries = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    countriesAutocompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Countries"),
          actions: [
            IconButton(
              icon: Icon(Icons.sunny),
              onPressed: () => null,
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => null,
            )
          ],
        ),
        body: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Autocomplete<Country>(
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
                setState(() => _selectedCountry = suggestion);
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController controller,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                countriesAutocompleteController = controller;
                return TextFormField(
                  controller: countriesAutocompleteController,
                  enableSuggestions: false,
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  decoration: InputDecoration(
                    labelText: "Country",
                    hintText: "Enter a country name",
                    prefix: const Icon(Icons.person),
                    suffixIcon: countriesAutocompleteController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() =>
                                  countriesAutocompleteController.clear());
                            },
                          )
                        : null,
                  ),
                  validator: (String? value) {
                    // If the hit is not an exact match, clear lga field and show error text
                    final matchingCountries = countries.where((aState) =>
                        aState.name.toLowerCase() == value?.toLowerCase());

                    if (matchingCountries.length == 1 &&
                        countries.elementAt(0) == matchingCountries.first) {
                      _selectedCountry = matchingCountries.first;
                      return null;
                    }

                    // Keep this here to avoid validation getting triggered when form loads, until the user interacts with the field
                    if (value == null ||
                        value.isEmpty ||
                        matchingCountries.isEmpty) {
                      return 'Please select a country';
                    }

                    // localGovernmentOfOriginAutocompleteController?.clear();

                    return null;
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.language),
                    onPressed: () => null,
                    label: Text("EN")),
                TextButton.icon(
                    icon: Icon(Icons.filter),
                    onPressed: () => null,
                    label: Text("Filter")),
              ],
            ),
            Flexible(
              child: FutureBuilder(
                future: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Country>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Text("flag"),
                            title: const Text('country name'),
                            subtitle: const Text('capital'),
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CountryDetailsScreen(),
                            )),
                          );
                        },
                      );
                    }
                  }
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Color(0xFF000F24),
                      semanticsLabel: "Loading countries",
                      strokeWidth: 8,
                    ),
                  );
                  // }
                },
              ),
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
