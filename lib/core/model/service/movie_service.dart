import 'package:movie_app/core/constant/enum.dart';
import 'package:movie_app/core/model/entity/movie_response.dart';
import 'package:movie_app/core/model/entity/video.dart';
import 'package:movie_app/http/http_service.dart';

const _kMovieApiCollection = "/movie";

class MovieService {
  static Future<MovieResponse> fetchMovieFromLineup({int page = 1, required MovieLineup lineup}) async {
    final response = await HttpService.http.get('$_kMovieApiCollection/${lineup.apiResourcePath}', queryParameters: {
      "page": page,
    });
    return MovieResponse.fromJson(response.data);
  }

  static Future<List<Video>> fetchMovieTrailer({required int movie_id}) async {
    final response = await HttpService.http.get('$_kMovieApiCollection/$movie_id/videos', queryParameters: {
      "language": 'en-US',
    });
    final results = response.data['results'];
    final videos = <Video>[];
    if (results != null) {
      results.forEach((v) {
        videos.add(Video.fromJson(v));
      });
    }
    return videos;
  }
}
