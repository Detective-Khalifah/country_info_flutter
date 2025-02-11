import 'package:country_info_flutter/models/country.dart';
import 'package:flutter/material.dart';

class CountryDetailsScreen extends StatelessWidget {
  final Country country;
  const CountryDetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(country.name),
        ),
      ),
    );
  }
}
