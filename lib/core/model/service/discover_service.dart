import 'package:dio/dio.dart';
import 'package:movie_app/core/model/entity/pageable_movie_response.dart';
import 'package:movie_app/http/http_service.dart';

const _kDiscoverApiCollection = "/discover";

class DiscoverService {
  static Future<PageableMovieResponse?> discoverMoviesByGenre({int page = 1, required int genre_id}) async {
    try {
      final response = await HttpService.http.get(
        '$_kDiscoverApiCollection/movie',
        queryParameters: {
          "language": "en-US",
          "with_genres": "$genre_id",
          "page": page,
        },
      );
      return PageableMovieResponse.fromJson(response.data);
    } on DioException catch (e) {}
  }
}