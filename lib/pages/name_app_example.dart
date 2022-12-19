import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person update({
    String? name,
    int? age,
  }) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
      uuid: uuid,
    );
  }

  String get displayName => '$name ($age years old)';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  // *NOTE: the hashcode usually fill with the params that been compared
  // * if there is more params, we can use Object.hash(params1, params2) or Object.hashAll() to combine them
  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';
}

// *NOTE: last video https://youtu.be/vtGCteFYs4M?t=6996

class DataModel extends ChangeNotifier {
  final List<Person> _persons = [];
  int get count => _persons.length;

  UnmodifiableListView<Person> get persons => UnmodifiableListView(_persons);

  void add(Person person) {
    _persons.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _persons.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    final index = _persons.indexOf(updatedPerson);
    final oldDataPerson = _persons[index];
    if (oldDataPerson.name != updatedPerson.name || oldDataPerson.age != updatedPerson.age) {
      _persons[index] = oldDataPerson.update(
        name: updatedPerson.name,
        age: updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider<DataModel>(
  (_) => DataModel(),
);

class NameAppExample extends ConsumerWidget {
  const NameAppExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name App'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final dataModel = ref.watch(peopleProvider);
          return ListView.builder(
            itemCount: dataModel.count,
            itemBuilder: (context, index) {
              final person = dataModel.persons[index];
              return ListTile(
                title: GestureDetector(
                    onTap: () async {
                      final updatedPerson = await createOrUpdatePersonDialog(context, exisitingPerson: person);

                      if (updatedPerson != null) {
                        dataModel.update(updatedPerson);
                      }
                    },
                    child: Text(person.displayName)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    dataModel.remove(person);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPerson = await createOrUpdatePersonDialog(context);
          if (newPerson != null) {
            ref.read(peopleProvider).add(newPerson);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(
  BuildContext context, {
  Person? exisitingPerson,
}) {
  String? name = exisitingPerson?.name;
  int? age = exisitingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';

  return showDialog<Person>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create a Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Emter name here ...',
              ),
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Emter age here ...',
              ),
              onChanged: (value) => age = int.tryParse(value),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (name != null && age != null) {
                if (exisitingPerson != null) {
                  final newPerson = exisitingPerson.update(name: name, age: age);
                  Navigator.of(context).pop(newPerson);
                } else {
                  //no existing person, create new one
                  final newPerson = Person(
                    name: name!,
                    age: age!,
                  );
                  Navigator.of(context).pop(newPerson);
                }
              } else {
                //no name or age or both
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
}
