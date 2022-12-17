import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//give ten random names
const names = [
  'John',
  'Paul',
  'George',
  'Alice',
  'Bob',
  'Charlie',
  'Dave',
  'Eve',
  'Frank',
  'Grace',
  'Hannah',
  'Ivan',
  'Judy',
  'Karl',
  'Linda',
  'Mike',
  'Nancy',
  'Oscar',
  'Peggy',
  'Quentin',
  'Ruth',
  'Steve',
  'Tina',
  'Ursula',
  'Victor',
  'Wendy',
  'Xavier',
  'Yvonne',
  'Zach',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (i) => i + 1,
  ),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(
          0,
          count,
        ),
      ),
);

class StreamProviderExample extends ConsumerWidget {
  const StreamProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Provider Example'),
      ),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(names.elementAt(index)),
              );
            },
          );
        },
        error: (error, stack) => const Text('Reach the end of the list'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
