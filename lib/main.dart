import 'package:country_info_flutter/providers/theme.dart';
import 'package:country_info_flutter/screens/countries_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Country Info',
      theme: themeNotifier.lightTheme,
      darkTheme: themeNotifier.darkTheme,
      themeMode: themeMode,
      home:
          CountriesListScreen(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
