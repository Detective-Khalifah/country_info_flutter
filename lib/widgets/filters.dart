import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/providers/country_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Filters extends ConsumerWidget {
  const Filters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current list of selected continents
    final selectedContinent = ref.watch(selectedContinentProvider);
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
                  ref.read(selectedContinentProvider.notifier).state = "";
                  ref.read(selectedTimezonesProvider.notifier).state = [];
                  ref.read(selectedLanguageProvider.notifier).state = null;
                },
                child: Text("Reset"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Apply filters and pop
                  // ref.read(selectedContinentProvider.notifier).state =
                  //     selectedContinent;
                  ref.invalidate(countriesProvider); // Clear previous data
                  ref.read(filtersProvider.notifier).state =
                      ({"region": selectedContinent});
                  ref.read(countriesProvider);
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
                return RadioListTile.adaptive(
                  title: Text(continent.key),
                  value: continent.key,
                  groupValue: selectedContinent,
                  onChanged: (value) {
                    ref.read(selectedContinentProvider.notifier).state = value;
                    print(
                        "Previous selected continent: $selectedContinent. Current continent: $value");
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
