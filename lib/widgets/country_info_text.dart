import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryInfoText extends StatelessWidget {
  final String label;
  final String value;

  const CountryInfoText({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .titleMedium, //DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
        children: [
          TextSpan(
            text: "$label: ",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.notoSansSymbols(),
          ),
        ],
      ),
    );
  }
}
