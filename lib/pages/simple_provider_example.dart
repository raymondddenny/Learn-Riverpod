import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentDate = Provider<DateTime>(
  (ref) => DateTime.now(),
);

class SimpleProviderExample extends ConsumerWidget {
  const SimpleProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooks Riverpod'),
      ),
      body: Center(
        child: Text(
          date.toIso8601String(),
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
