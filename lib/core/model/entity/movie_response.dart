import 'package:movie_app/core/model/entity/movie.dart';

class MovieResponse {
  int? page;
  List<Movie>? movies;
  int? totalPages;
  int? totalResults;

  MovieResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      movies = <Movie>[];
      json['results'].forEach((v) {
        movies!.add(Movie.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    if (movies != null) {
      data['results'] = movies!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}
