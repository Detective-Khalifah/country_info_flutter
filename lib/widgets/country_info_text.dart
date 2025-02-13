import 'package:flutter/material.dart';

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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Color(0xFF1C1917),
                ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFFF2F4F7)
                    : Colors.grey),
          ),
        ],
      ),
    );
  }
}
