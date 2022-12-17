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
    () =>
        {
          City.stockholm: '🌧',
          City.paris: '⛅',
          City.tokyo: '🌞',
          City.jakarta: '💨',
        }[city] ?? // "city" is the key that been passed to the function
        '?',
  );
}

//UI write to this and read from this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '🤷🏻';
// UI reads this
final wetherProvider = FutureProvider<WeatherEmoji>((ref) async {
  // listen to change in currenyCityProvider
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return await getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

class FutureProviderExample extends ConsumerWidget {
  const FutureProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(wetherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App Example'),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (weather) => Text(
              weather,
              style: const TextStyle(fontSize: 40),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Text(error.toString()),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(city.toString()),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : null,
                  onTap: () {
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
