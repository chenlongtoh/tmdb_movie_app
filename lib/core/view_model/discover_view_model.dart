import 'package:flutter/material.dart';
import 'package:movie_app/core/model/entity/discover_response.dart';
import 'package:movie_app/core/model/entity/genre.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/service/discover_service.dart';
import 'package:movie_app/core/model/service/genre_service.dart';
import 'package:movie_app/core/model/service/movie_service.dart';

enum LoadState {
  initializing,
  loadingMovie,
  completed,
  errored,
}

class DiscoverViewModel extends ChangeNotifier {
  LoadState loadState = LoadState.initializing;
  Map<Genre, DiscoverMovieResponse> genreMovieCache = {};
  List<Genre> genreList = [];

  Genre? selectedGenre;

  void selectGenre(Genre genre) async {
    selectedGenre = genre;
    if (genreMovieCache[genre] == null) {
      setLoadState(LoadState.loadingMovie);
      await fetchMoviesByGenre(genre);
      setLoadState(LoadState.completed);
    }
  }

  List<Movie> getMovies() => genreMovieCache[selectedGenre]?.movies ?? [];

  DiscoverViewModel() {
    _init();
  }

  //TODO: Add persistence & load
  Future<void> _init() async {
    setLoadState(LoadState.initializing);
    genreList = await GenreService.fetchMovieGenre();
    if (genreList.isNotEmpty) {
      selectedGenre = genreList.first;
      await fetchMoviesByGenre(selectedGenre!);
    }
    setLoadState(LoadState.completed);
  }

  //TODO: Add persistence & load
  Future<List<Movie>> fetchMoviesByGenre(Genre genre) async {
    int page = 1;
    if (genreMovieCache[genre] != null) {
      page = genreMovieCache[genre]!.page! + 1;
    }
    final response = await DiscoverService.discoverMoviesByGenre(page: page, genre_id: genre.id!);
    if (response != null) {
      genreMovieCache[genre] = response;
    }

    return genreMovieCache[genre]?.movies ?? [];
  }

  void setLoadState(LoadState state) {
    loadState = state;
    notifyListeners();
  }

  Future<List<Movie>> loadMovies() async {
    return await fetchMoviesByGenre(selectedGenre!);
  }
}
