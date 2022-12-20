import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copy({
    required bool isFavorite,
  }) =>
      Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() => 'Film(id: $id, title: $title, description: $description, isFavorite: $isFavorite)';

  @override
  bool operator ==(covariant Film other) => id == other.id && isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hash(id, isFavorite);
}

const AllFilms = [
  Film(
    id: '1',
    title: 'The Shawshank Redemption',
    description: 'Description of The Shawshank Redemption',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'The Godfather',
    description: 'Description of The Godfather',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'The Dark Knight',
    description: 'Description of The Dark Knight',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'The Godfather: Part II',
    description: 'Description of The Godfather: Part II',
    isFavorite: false,
  ),
  Film(
    id: '5',
    title: 'The Lord of the Rings: The Return of the King',
    description: 'Description of The Lord of the Rings: The Return of the King',
    isFavorite: false,
  ),
  Film(
    id: '6',
    title: 'Pulp Fiction',
    description: 'Description of Pulp Fiction',
    isFavorite: false,
  ),
];

class FilmNotifier extends StateNotifier<List<Film>> {
  FilmNotifier() : super(AllFilms);

  void toggleFavorite({required Film film, required bool isFavorite}) {
    state = state.map((thisFilm) {
      if (thisFilm.id == film.id) {
        return thisFilm.copy(isFavorite: isFavorite);
      }
      return thisFilm;
    }).toList();
  }
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

// favorites status provider
final favoriteStatusProvider = StateProvider<FavoriteStatus>((_) => FavoriteStatus.all);

//all fils
final allFilmsProivder = StateNotifierProvider<FilmNotifier, List<Film>>((_) => FilmNotifier());

// favorite films
final favoriteFilmsProvider = Provider<Iterable<Film>>((ref) {
  final allFilms = ref.watch(allFilmsProivder);
  return allFilms.where((film) => film.isFavorite);
});

// not favorite films
final nonFavoriteFilmsProvider = Provider<Iterable<Film>>((ref) {
  final allFilms = ref.watch(allFilmsProivder);
  return allFilms.where((film) => !film.isFavorite);
});

class FilmListApp extends ConsumerWidget {
  const FilmListApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film List App'),
      ),
      body: Column(
        children: [
          const FilteredFilmWidget(),
          Consumer(
            builder: (context, ref, child) {
              final currentFilter = ref.watch(favoriteStatusProvider);
              switch (currentFilter) {
                case FavoriteStatus.all:
                  return FilmList(filmsProvider: allFilmsProivder);
                case FavoriteStatus.favorite:
                  return FilmList(filmsProvider: favoriteFilmsProvider);
                case FavoriteStatus.notFavorite:
                  return FilmList(filmsProvider: nonFavoriteFilmsProvider);
              }
            },
          )
        ],
      ),
    );
  }
}

class FilmList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> filmsProvider;
  const FilmList({required this.filmsProvider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(filmsProvider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final favoriteIcon = film.isFavorite ? Icons.favorite : Icons.favorite_border;
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              icon: Icon(favoriteIcon),
              onPressed: () {
                final isFavorite = !film.isFavorite;
                ref.read(allFilmsProivder.notifier).toggleFavorite(
                      film: film,
                      isFavorite: isFavorite,
                    );
              },
            ),
          );
        },
      ),
    );
  }
}

class FilteredFilmWidget extends StatelessWidget {
  const FilteredFilmWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentFavoriteStatus = ref.watch(favoriteStatusProvider);
        return DropdownButton(
          value: currentFavoriteStatus,
          onChanged: (value) {
            ref.read(favoriteStatusProvider.notifier).state = value as FavoriteStatus;
          },
          items: FavoriteStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.toString().split('.').last),
            );
          }).toList(),
        );
      },
    );
  }
}
