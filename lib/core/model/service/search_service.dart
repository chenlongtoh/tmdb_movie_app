import 'package:dio/dio.dart';
import 'package:movie_app/core/model/entity/pageable_movie_response.dart';
import 'package:movie_app/http/http_service.dart';

const _kSearchApiCollection = "/search";

class SearchService {
  static Future<PageableMovieResponse?> searchMoviesByKeyword({int page = 1, required String title}) async {
    try {
      final response = await HttpService.http.get(
        '$_kSearchApiCollection/movie',
        queryParameters: {
          "language": "en-US",
          "query": title,
        },
      );
      return PageableMovieResponse.fromJson(response.data);
    } on DioException catch (e) {}
  }
}
