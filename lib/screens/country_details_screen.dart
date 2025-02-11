import 'dart:async';

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
  final List<String?> images = [];

  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    images.addAll([
      widget.country.flags?.svg,
      widget.country.coatOfArms?.svg,
      widget.country.maps?.googleMaps,
      widget.country.maps?.openStreetMaps
    ]);

    // Change page every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageIndex = ref.watch(imageIndexProvider);
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
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      if (images[index] != null) {
                        return Center(
                          child: images[imageIndex]!.endsWith(".svg")
                              ? SvgPicture.network(
                                  images[index]!,
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
                        );
                      }
                      if (images[index] == null) {
                        return Center(child: Text("No image"));
                      }
                    },
                  ),
                  // Left Arrow
                  Positioned(
                    left: 10,
                    top: 80,
                    child: IconButton(
                      icon: Icon(Icons.arrow_left, size: 32),
                      onPressed: () {
                        if (_currentPage > 0) {
                          _currentPage--;
                        } else {
                          _currentPage = images.length - 1;
                        }
                        if (_pageController.hasClients) {
                          _pageController.animateToPage(
                            _currentPage,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
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
                        if (_currentPage < images.length - 1) {
                          _currentPage++;
                        } else {
                          _currentPage = 0;
                        }
                        if (_pageController.hasClients) {
                          _pageController.animateToPage(
                            _currentPage,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
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
