import 'package:country_info_flutter/models/country.dart';
import 'package:country_info_flutter/providers/country_info_provider.dart';
import 'package:country_info_flutter/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Filters extends ConsumerWidget {
  const Filters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current list of selected continents
    final selectedContinent = ref.watch(selectedContinentProvider);
    final selectedTimezones = ref.watch(selectedTimezonesProvider);

    final themeNotifier = ref.watch(themeNotifierProvider.notifier);

    final List<String> availableTimezones = [
      ...List.generate(12, (int index) => "GMT +${index + 1}"),
      "GMT 0",
      ...List.generate(12, (int index) => "GMT -${index + 1}")
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            leading: Text(
              "Filter",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Continent Filter
          ExpansionTile(
            title: Text(
              "Continent",
              style: Theme.of(context).textTheme.titleMedium,
            ),
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

          // Timezone Filter
          ExpansionTile(
            // enabled: false,
            title: Text(
              "Timezone",
              style: Theme.of(context).textTheme.titleMedium,
            ),
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

          // Reset & Apply Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(selectedContinentProvider.notifier).state = "";
                    ref.read(selectedTimezonesProvider.notifier).state = [];
                    ref.read(selectedLanguageProvider.notifier).state = null;
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: themeNotifier.isLightMode()
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      padding: const EdgeInsets.all(4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    onPressed: () {
                      // Apply filters and pop
                      // ref.read(selectedContinentProvider.notifier).state =
                      //     selectedContinent;
                      ref.invalidate(countriesProvider); // Clear previous data
                      ref.read(filtersProvider.notifier).state =
                          ({"region": selectedContinent});
                      ref.read(countriesProvider);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Show results",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
