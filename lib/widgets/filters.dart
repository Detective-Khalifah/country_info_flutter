import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/providers/country_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Filters extends ConsumerWidget {
  const Filters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current list of selected continents
    final selectedContinents = ref.watch(selectedContinentsProvider);
    final selectedTimezones = ref.watch(selectedTimezonesProvider);

    final List<String> availableTimezones = [
      ...List.generate(12, (int index) => "UTC +${index + 1}"),
      "UTC 0",
      ...List.generate(12, (int index) => "UTC -${index + 1}")
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Filters")),
      // For some reason, setting `mainAxisAlignment: MainAxisAlignment.end,`
      //on [Column] didn't work -- children stuck to the top;
      //using Spacer() gave a RenderFlex error. Stick to ListView for now,
      //albeit layout order has to be reversed.
      body: ListView(
        reverse: true,
        children: [
          // Reset & Apply Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(selectedContinentsProvider.notifier).state = [];
                  ref.read(selectedTimezonesProvider.notifier).state = [];
                  ref.read(selectedLanguageProvider.notifier).state = null;
                },
                child: Text("Reset"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Apply filters and pop
                  Navigator.of(context).pop();
                },
                child: Text("Show results"),
              ),
            ],
          ),

          // Timezone Filter
          ExpansionTile(
            title: Text("Time Zone",
                style: Theme.of(context).textTheme.titleMedium),
            children: availableTimezones.map(
              (timezone) {
                return CheckboxListTile(
                  title: Text(timezone),
                  value: selectedTimezones.contains(timezone),
                  onChanged: (bool? checked) {
                    final notifier =
                        ref.read(selectedTimezonesProvider.notifier);
                    if (checked == true) {
                      if (!selectedTimezones.contains(timezone)) {
                        notifier.state = [...selectedTimezones, timezone];
                      }
                    } else {
                      notifier.state = selectedTimezones
                          .where((t) => t != timezone)
                          .toList();
                    }
                  },
                );
              },
            ).toList(),
          ),

          // Continent Filter
          ExpansionTile(
            title: Text("Continent",
                style: Theme.of(context).textTheme.titleMedium),
            children: continentValues.map.entries.map(
              (continent) {
                // continent.key is the display string (e.g., "Africa")
                // continent.value is the Continent enum value (e.g., Continent.AFRICA)
                return CheckboxListTile(
                  title: Text(continent.key),
                  value: selectedContinents.contains(continent.value),
                  onChanged: (checked) {
                    final notifier =
                        ref.read(selectedContinentsProvider.notifier);
                    if (checked == true) {
                      // Add the continent if it's not already selected
                      if (!selectedContinents.contains(continent.value)) {
                        notifier.state = [
                          ...selectedContinents,
                          continent.value
                        ];
                      }
                    } else {
                      // Remove the continent from the list
                      notifier.state = selectedContinents
                          .where((c) => c != continent.value)
                          .toList();
                    }
                  },
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
