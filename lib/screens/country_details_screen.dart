import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/providers/country_info_provider.dart';
import 'package:country_info_flutter/widgets/country_info_text.dart';
import 'package:country_info_flutter/widgets/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountryDetailsScreen extends ConsumerStatefulWidget {
  final Country country;
  const CountryDetailsScreen({super.key, required this.country});

  @override
  ConsumerState<CountryDetailsScreen> createState() =>
      _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends ConsumerState<CountryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final imageIndex = ref.watch(imageIndexProvider);
    final images = [
      widget.country.flags?.svg,
      widget.country.coatOfArms?.svg,
      widget.country.maps?.googleMaps,
      widget.country.maps?.openStreetMaps
    ];
    print("images: $images");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.country.name),
        ),
        body: ListView(
          // Image Carousel with Arrows
          children: [
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  if (images[imageIndex] != null)
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
                          : SizedBox(
                              width: 480,
                              height: 480,
                              child: MapView(mapUrl: images[imageIndex]!),
                            ),
                    ),
                  if (images[imageIndex] == null)
                    Center(child: Text("No image")),
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
                      label: "Population",
                      value: "${widget.country.population}"),
                  CountryInfoText(
                      label: "Official name",
                      value: widget.country.officialName),
                  CountryInfoText(
                      label: "Capital", value: widget.country.capitalCity),
                  if (widget.country.president != null)
                    CountryInfoText(
                        label: "Head of state",
                        value: "${widget.country.president?.name}"),
                  CountryInfoText(
                      label: "Region",
                      value: "${widget.country.continents?.first}"),
                  // CountryInfoText(
                  //     label: "Motto", value: "${country.population}"),
                  SizedBox(
                    height: 8,
                  ),
                  CountryInfoText(
                      label: "Country code", value: widget.country.countryCode),
                  SizedBox(height: 16),
                  CountryInfoText(
                      label: "Languages",
                      value:
                          widget.country.languages?.values.join(", ") ?? "N/A"),
                  // CountryInfoText(
                  //     label: "Official language",
                  //     value: "${country.population}"),
                  CountryInfoText(
                      label: "Currencies",
                      value: widget.country.currencies?.entries.map((e) {
                            final name = e.value.name;
                            final symbol = e.value.symbol;
                            return symbol.isNotEmpty ? "$name ($symbol)" : name;
                          }).join(", ") ??
                          "N/A"),
                  SizedBox(height: 16),
                  CountryInfoText(
                      label: "Timezone", value: "${widget.country.timezones}"),
                  CountryInfoText(
                      label: "Demonym", value: "${widget.country.population}"),
                  CountryInfoText(
                      label: "Driving side",
                      value: "${widget.country.population}"),
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
}
