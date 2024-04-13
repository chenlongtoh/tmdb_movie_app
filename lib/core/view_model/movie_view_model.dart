import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/constant/enum.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/entity/movie_response.dart';
import 'package:movie_app/core/model/service/movie_service.dart';

const mainLineup = MovieLineup.nowPlaying;

class MovieViewModel extends ChangeNotifier {
  bool isLoading = false;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  final Map<MovieLineup, MovieResponse> _lastFetchMovieConfig = {};
  final Map<MovieLineup, List<Movie>> _moviesMap = {};

  List<Movie> get nowPlayingMovies => List.from(_moviesMap[MovieLineup.nowPlaying] ?? []);
  List<Movie> get popular => List.from(_moviesMap[MovieLineup.popular] ?? []);
  List<Movie> get topRated => List.from(_moviesMap[MovieLineup.topRated] ?? []);
  List<Movie> get upcoming => List.from(_moviesMap[MovieLineup.upcoming] ?? []);

  MovieViewModel() {
    init();
  }

  Future<void> init() async {
    setLoading(true);
    try {
      // Fetch movie
      await Future.forEach(MovieLineup.values, (lineup) async {
        final response = await MovieService.fetchMovieFromLineup(lineup: lineup);
        _lastFetchMovieConfig[lineup] = response;
        _moviesMap[lineup] = response.movies ?? [];
      });

      // Preemptive load trailer for movies in main lineup
      if (_moviesMap[mainLineup] != null) {
        await Future.forEach(_moviesMap[mainLineup]!, (movie) async {
          final videos = await MovieService.fetchMovieTrailer(movie_id: movie.id!);
          movie.trailers = videos.where((video) => video.type == "Trailer").toList();
          movie.teasers = videos.where((video) => video.type == "Teaser").toList();
        });
      }
    } on DioException catch (e) {
      print("@@ Error => $e");
    }
    print("@@ nowPlayingMovies => ${nowPlayingMovies.length}");
    setLoading(false);
  }

  Future<void> loadMovieLineup(MovieLineup lineup) async {
    final int? currentPage = _lastFetchMovieConfig[lineup]?.totalPages;
    final int? totalPage = _lastFetchMovieConfig[lineup]?.totalPages;
    if (totalPage != null && currentPage != null && currentPage < totalPage) {
      final response = await MovieService.fetchMovieFromLineup(lineup: lineup);
      _lastFetchMovieConfig[lineup] = response;
      if (response.movies?.isNotEmpty ?? false) {
        if (_moviesMap[lineup] != null) {
          _moviesMap[lineup]!.addAll(response.movies!);
        } else {
          _moviesMap[lineup] = response.movies!;
        }
      }
    } else {
      //To-do: Custom Exception + handling
      throw Exception();
    }
    notifyListeners();
  }
}
