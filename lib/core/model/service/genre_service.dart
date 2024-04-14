import 'package:dio/dio.dart';
import 'package:movie_app/core/model/entity/genre.dart';
import 'package:movie_app/http/http_service.dart';

const _kGenreApiCollection = "/genre";

class GenreService {
  static Future<List<Genre>> fetchMovieGenre() async {
    try {
      final response = await HttpService.http.get('$_kGenreApiCollection/movie/list', queryParameters: {"language": "en"});
      final results = response.data['genres'];
      final genres = <Genre>[];
      if (results != null) {
        results.forEach((v) {
          genres.add(Genre.fromJson(v));
        });
      }

      return genres;
    } on DioException catch (e) {
      //TODO: Handle exception gracefully
      return [];
    }
  }
}
