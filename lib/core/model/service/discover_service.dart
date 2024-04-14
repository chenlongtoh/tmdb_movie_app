import 'package:dio/dio.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/entity/pageable_movie_response.dart';
import 'package:movie_app/hive/hive_manager.dart';
import 'package:movie_app/http/connectivity_observer.dart';
import 'package:movie_app/http/http_service.dart';

const _kDiscoverApiCollection = "/discover";

class DiscoverService {
  static Future<PageableMovieResponse?> discoverMoviesByGenre({int page = 1, required int genre_id}) async {
    try {
      if (!ConnectivityObserver().connected) {
        final movies = HiveManager().movieBox.values.where((movie) => movie.genreIds?.contains(genre_id) ?? false).toList();
        return PageableMovieResponse(
          movies: movies,
          page: 1,
          totalPages: 1,
          totalResults: movies.length,
        );
      }

      final response = await HttpService.http.get(
        '$_kDiscoverApiCollection/movie',
        queryParameters: {
          "language": "en-US",
          "with_genres": "$genre_id",
          "page": page,
        },
      );
      final pageableResponse = PageableMovieResponse.fromJson(response.data);
      for (Movie movie in pageableResponse.movies ?? []) {
        HiveManager().movieBox.put(movie.id, movie);
      }
      return pageableResponse;
    } on DioException catch (e) {}
  }
}
