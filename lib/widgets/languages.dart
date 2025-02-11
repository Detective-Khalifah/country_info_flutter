import 'package:country_info_flutter/providers/country_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Languages extends ConsumerWidget {
  const Languages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List of available languages
    final availableLanguages = ["English", "French", "Spanish", "German"];
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Languages")),
        // Language Dropdown
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: availableLanguages.length,
          itemBuilder: (context, index) {
            final language = availableLanguages[index];
            return RadioListTile.adaptive(
              title: Text(language),
              value: language,
              groupValue: selectedLanguage,
              onChanged: (value) {
                ref.read(selectedLanguageProvider.notifier).state = value;
                Navigator.of(context).pop();
              },
            );
          },
        ),
        // DropdownButton<String>(
        //   value: selectedLanguage,
        //   hint: Text("Select Language"),
        //   onChanged: (value) =>
        //       ref.read(selectedLanguageProvider.notifier).state = value,
        //   items: availableLanguages.map((lang) {
        //     return DropdownMenuItem(value: lang, child: Text(lang));
        //   }).toList(),
        // ),
      ),
    );
  }
}
