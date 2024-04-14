import 'package:movie_app/core/model/entity/video.dart';
import 'package:hive/hive.dart';
part 'movie.g.dart';

@HiveType(typeId: 1)
class Movie extends HiveObject {
  @HiveField(0)
  String? backdropPath;

  @HiveField(1)
  List<int>? genreIds;

  @HiveField(2)
  int? id;

  @HiveField(3)
  String? overview;

  @HiveField(4)
  double? popularity;

  @HiveField(5)
  String? posterPath;

  @HiveField(6)
  String? releaseDate;

  @HiveField(7)
  String? title;

  @HiveField(8)
  bool? video;

  @HiveField(9)
  double? voteAverage;

  @HiveField(10)
  int? voteCount;

  @HiveField(11)
  List<Video>? trailers;

  @HiveField(12)
  List<Video>? teasers;

  Movie({
    this.backdropPath,
    this.genreIds,
    this.id,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  Movie.fromJson(Map<String, dynamic> json) {
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backdrop_path'] = backdropPath;
    data['genre_ids'] = genreIds;
    data['id'] = id;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['release_date'] = releaseDate;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}
