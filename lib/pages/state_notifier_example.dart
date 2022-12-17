import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../extensions/extensions.dart';

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void incrementCounter() => state = state == null ? 1 : state + 1;
  void decrementCounter() => state = (state ?? 0) - 1;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class StateNotifierExample extends ConsumerWidget {
  const StateNotifierExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the state counter changes
    // final counterValue = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Notifier Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final counter = ref.watch(counterProvider);
              final text = counter == null ? 'Pressed the + button' : 'Counter: $counter';
              return Text(text);
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              ref.read(counterProvider.notifier).incrementCounter();
            },
            child: const Text('Increment'),
          ),
          ElevatedButton(
            onPressed: ref.watch(counterProvider) == null
                ? null
                : () {
                    ref.read(counterProvider.notifier).decrementCounter();
                  },
            child: const Text('Decrement'),
          ),
        ],
      ),
    );
  }
}
