import 'package:dio/dio.dart';
import 'package:movie_app/core/model/entity/genre.dart';
import 'package:movie_app/hive/hive_manager.dart';
import 'package:movie_app/http/connectivity_observer.dart';
import 'package:movie_app/http/http_service.dart';

const _kGenreApiCollection = "/genre";

class GenreService {
  static Future<List<Genre>> fetchMovieGenre() async {
    try {
      if (!ConnectivityObserver().connected) {
        return HiveManager().genreBox.values.toList();
      }

      final response = await HttpService.http.get('$_kGenreApiCollection/movie/list', queryParameters: {"language": "en"});
      final results = response.data['genres'];
      final genres = <Genre>[];
      if (results != null) {
        results.forEach((v) {
          genres.add(Genre.fromJson(v));
        });
      }

      for (Genre genre in genres) {
        HiveManager().genreBox.put(genre.id, genre);
      }
      return genres;
    } on DioException catch (e) {
      //TODO: Handle exception gracefully
      return [];
    }
  }
}
