import 'dart:async';
import 'package:intl/intl.dart';
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

    // Change page every 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      }
      // else {
      //   _currentPage = 0;
      // }
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
    // String continent = widget.country.continents?.first.toString().map((x) => continentValues.map[x]!));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.country.name),
          centerTitle: true,
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
                      final image = images[index];
                      if (image != null) {
                        return Center(
                          child: !image.endsWith(".svg")
                              ? SizedBox(
                                  width: 480,
                                  height: 480,
                                  child: MapView(mapUrl: image),
                                )
                              : SvgPicture.network(
                                  image,
                                  height: 240,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator(),
                                  ),
                                ),
                        );
                      }
                      // if (images[index] == null) {
                      return Center(child: Text("No image"));
                      // }
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
                      label: "Official name",
                      value: widget.country.officialName),
                  CountryInfoText(
                      label: "Population",
                      value: NumberFormat.compact(locale: "en_US")
                          .format(widget.country.population)),
                  CountryInfoText(
                      label: "Capital", value: widget.country.capitalCity),
                  if (widget.country.continents != null)
                    CountryInfoText(
                        label: "Continent",
                        value: widget.country.continents!
                            .map((continent) =>
                                continentValues.reverse[continent])
                            .join(", ")),
                  if (widget.country.subContinent != null)
                    CountryInfoText(
                        label: "Sub-continent:",
                        value: widget.country.subContinent!),
                  SizedBox(height: 16),
                  // CountryInfoText(
                  //     label: "Motto", value: "${country.motto}"),
                  if (widget.country.president != null)
                    CountryInfoText(
                        label: "Head of state",
                        value: "${widget.country.president?.name}"),
                  CountryInfoText(
                      label: "Official languages",
                      value:
                          widget.country.languages?.values.join(", ") ?? "N/A"),

                  CountryInfoText(
                      label: "Country code", value: widget.country.countryCode),
                  if (widget.country.idd.root != null ||
                      widget.country.idd.suffixes != null)
                    CountryInfoText(
                      label: "International dialing code",
                      value: widget.country.idd.root! +
                          widget.country.idd.suffixes!.join(", "),
                    ),
                  if (widget.country.tld != null &&
                      widget.country.tld!.isNotEmpty)
                    CountryInfoText(
                        label: "Top-level internet domain",
                        value: widget.country.tld!.join(",")),
                  CountryInfoText(
                      label: "Timezone",
                      value: widget.country.timezones.join(",")),
                  SizedBox(height: 16),
                  CountryInfoText(
                    label: "Start of Week",
                    value: widget.country.startOfWeek.name[0] +
                        widget.country.startOfWeek.name
                            .substring(1)
                            .toLowerCase(),
                  ),
                  CountryInfoText(
                    label: "Currencies",
                    value: widget.country.currencies?.entries.map((e) {
                          final name = e.value.name;
                          final symbol = e.value.symbol;
                          return symbol.isNotEmpty ? "$name ($symbol)" : name;
                        }).join(", ") ??
                        "N/A",
                  ),
                  if (widget.country.independent != null)
                    CountryInfoText(
                        label: "Independent",
                        value: widget.country.independent! ? "Aye" : "Nay"),
                  CountryInfoText(
                      label: "United Nations Member",
                      value: widget.country.unMember ? "Yes" : "No"),
                  // CountryInfoText(
                  //     label: "Demonym", value: "${widget.country.population}"),
                  CountryInfoText(
                    label: "Driving side",
                    value: widget.country.car.side.name[0] +
                        widget.country.car.side.name.substring(1).toLowerCase(),
                  ),
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
