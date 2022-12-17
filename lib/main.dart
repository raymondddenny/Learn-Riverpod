import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learn_riverpo_example/pages/future_provider_example.dart';
import 'package:learn_riverpo_example/pages/simple_provider_example.dart';
import 'package:learn_riverpo_example/pages/state_notifier_example.dart';
import 'package:learn_riverpo_example/pages/stream_provider_example.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

final listOfExampleProvider = Provider<List<String>>(
  (ref) => [
    'Simple Provider Example',
    'State Notifier Example',
    'Future Provider Example',
    'Stream Provider Example',
  ],
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listPageExample = ref.watch(listOfExampleProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Example Den'),
      ),
      body: ListView.builder(
        itemCount: listPageExample.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(listPageExample[index]),
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleProviderExample(),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StateNotifierExample(),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FutureProviderExample(),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StreamProviderExample(),
                    ),
                  );
                  break;
              }
            },
          );
        },
      ),
    );
  }
}
