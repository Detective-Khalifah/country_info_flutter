import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/providers/country_info_provider.dart';
import 'package:country_info_flutter/widgets/country_info_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryDetailsScreen extends ConsumerWidget {
  final Country country;
  const CountryDetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageIndex = ref.watch(imageIndexProvider);
    final images = [
      country.flags?.svg,
      country.coatOfArms?.svg,
      country.maps?.googleMaps,
      country.maps?.openStreetMaps
    ];
    print("images: $images");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(country.name),
        ),
        body: ListView(
          // Image Carousel with Arrows
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Center(
                    child: images[imageIndex]!.endsWith(".svg")
                        ? SvgPicture.network(
                            images[imageIndex]!,
                            height: 240,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : TextButton.icon(
                            label: Text("Map"),
                            icon: Icon(Icons.map, size: 200),
                            onPressed: () => _openMap(images[imageIndex]!),
                          ),
                  ),
                  // Left Arrow
                  Positioned(
                    left: 10,
                    top: 80,
                    child: IconButton(
                      icon: Icon(Icons.arrow_left, size: 32),
                      onPressed: () {
                        ref.read(imageIndexProvider.notifier).state =
                            (imageIndex - 1) % images.length;
                      },
                    ),
                  ),
                  // Right Arrow
                  Positioned(
                    right: 10,
                    top: 80,
                    child: IconButton(
                      icon: Icon(Icons.arrow_right, size: 32),
                      onPressed: () {
                        ref.read(imageIndexProvider.notifier).state =
                            (imageIndex + 1) % images.length;
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Country Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CountryInfoText(
                      label: "Population", value: "${country.population}"),
                  CountryInfoText(
                      label: "Official name", value: country.officialName),
                  CountryInfoText(label: "Capital", value: country.capitalCity),
                  CountryInfoText(
                      label: "Head of state",
                      value: "${country.president?.name}"),
                  CountryInfoText(
                      label: "Region", value: "${country.continents?.first}"),
                  // CountryInfoText(
                  //     label: "Motto", value: "${country.population}"),
                  SizedBox(
                    height: 8,
                  ),
                  CountryInfoText(
                      label: "Country code", value: country.countryCode),
                  SizedBox(height: 16),
                  CountryInfoText(
                      label: "Languages",
                      value: country.languages?.values.join(", ") ?? "N/A"),
                  // CountryInfoText(
                  //     label: "Official language",
                  //     value: "${country.population}"),
                  CountryInfoText(
                      label: "Currencies",
                      value: country.currencies?.entries.map((e) {
                            final name = e.value.name;
                            final symbol = e.value.symbol;
                            return symbol.isNotEmpty
                                ? "$name (${symbol})"
                                : name;
                          }).join(", ") ??
                          "N/A"),
                  SizedBox(height: 16),
                  CountryInfoText(
                      label: "Timezone", value: "${country.timezones}"),
                  CountryInfoText(
                      label: "Demonym", value: "${country.population}"),
                  CountryInfoText(
                      label: "Driving side", value: "${country.population}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String forceUnicode(String symbol) {
    return symbol.runes.map((e) => (e.toRadixString(32))).join();
    // return symbol.runes.map((e) => String.fromCharCode(e)).join();
  }

  Future<void> _openMap(String uri) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url /*, mode: LaunchMode.externalApplication*/)) {
      throw 'Could not launch $url';
    }
  }
}
