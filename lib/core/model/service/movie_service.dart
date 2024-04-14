import 'package:dio/dio.dart';
import 'package:movie_app/core/constant/enum.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/entity/video.dart';
import 'package:movie_app/hive/hive_manager.dart';
import 'package:movie_app/http/http_service.dart';

const _kMovieApiCollection = "/movie";

class MovieService {
  static Future<List<Movie>> fetchMovieFromLineup({int page = 1, required MovieLineup lineup, bool fetchTrailer = false}) async {
    try {
      final response = await HttpService.http.get(
        '$_kMovieApiCollection/${lineup.apiResourcePath}',
        queryParameters: {
          "page": page,
          "language": "en-US",
        },
      );
      final results = response.data['results'];
      final movies = <Movie>[];
      if (results != null) {
        results.forEach((v) {
          movies.add(Movie.fromJson(v));
        });
      }

      if (fetchTrailer && movies.isNotEmpty) {
        await Future.forEach(movies, (movie) async {
          final videos = await MovieService._fetchMovieTrailer(movie_id: movie.id!);
          movie.trailers = videos.where((video) => video.type == "Trailer").toList();
          movie.teasers = videos.where((video) => video.type == "Teaser").toList();
        });
      }
      for (Movie movie in movies) {
        HiveManager().movieBox.put(movie.id, movie);
      }
      return movies;
    } on DioException catch (e) {
      //TODO: Handle exception gracefully
      return [];
    }
  }

  static Future<List<Video>> _fetchMovieTrailer({required int movie_id}) async {
    try {
      final response = await HttpService.http.get(
        '$_kMovieApiCollection/$movie_id/videos',
        queryParameters: {
          "language": "en-US",
        },
      );
      final results = response.data['results'];
      final videos = <Video>[];
      if (results != null) {
        results.forEach((v) {
          videos.add(Video.fromJson(v));
        });
      }
      for (Video video in videos) {
        HiveManager().videoBox.put(video.id, video);
      }
      return videos;
    } on DioException catch (e) {
      //TODO: Handle exception gracefully
      return [];
    }
  }
}
