import 'package:hive/hive.dart';
import 'package:movie_app/core/constant/enum.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/entity/genre.dart';
import 'package:movie_app/core/model/entity/video.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  static final HiveManager _singleton = HiveManager._internal();
  factory HiveManager() => _singleton;
  HiveManager._internal();

  late Box<List<int>> lineupMovieIdMapBox;
  late Box<Movie> movieBox;
  late Box<Video> videoBox;
  late Box<Genre> genreBox;

  init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    await registerAdapters();
    await openBoxes();
  }

  Future<void> registerAdapters() async {
    Hive.registerAdapter(MovieAdapter());
    Hive.registerAdapter(VideoAdapter());
    Hive.registerAdapter(GenreAdapter());
  }

  Future<void> openBoxes() async {
    lineupMovieIdMapBox = await Hive.openBox<List<int>>('lineupMovieIdMapBox');
    movieBox = await Hive.openBox<Movie>('movies');
    videoBox = await Hive.openBox<Video>('videos');
    genreBox = await Hive.openBox<Genre>('genres');
  }
}
