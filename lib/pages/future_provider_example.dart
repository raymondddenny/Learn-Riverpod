import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  stockholm,
  paris,
  tokyo,
  jakarta,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) async {
  return await Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.stockholm: '🌧',
      City.paris: '⛅',
      City.tokyo: '🌞',
      City.jakarta: '💨',
    }[city]!,
  );
}

class FutureProviderExample extends ConsumerWidget {
  const FutureProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the state counter changes
    // final counterValue = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App Example'),
      ),
    );
  }
}
