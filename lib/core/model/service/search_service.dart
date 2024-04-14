import 'package:dio/dio.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/entity/pageable_movie_response.dart';
import 'package:movie_app/hive/hive_manager.dart';
import 'package:movie_app/http/connectivity_observer.dart';
import 'package:movie_app/http/http_service.dart';

const _kSearchApiCollection = "/search";

class SearchService {
  static Future<List<Movie>?> searchMoviesByKeyword({required String title}) async {
    try {
      if (!ConnectivityObserver().connected) {
        return HiveManager().movieBox.values.where((movie) {
          if (movie.title == null) return false;
          final regex = RegExp("(${movie.title!.toLowerCase()})");
          return regex.hasMatch(title.toLowerCase());
        }).toList();
      }

      final response = await HttpService.http.get(
        '$_kSearchApiCollection/movie',
        queryParameters: {
          "language": "en-US",
          "query": title,
        },
      );
      final movies = PageableMovieResponse.fromJson(response.data).movies;
      for (Movie movie in movies ?? []) {
        HiveManager().movieBox.put(movie.id, movie);
      }
      return movies ?? [];
    } on DioException catch (e) {}
  }
}
