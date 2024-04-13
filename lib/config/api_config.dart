class ApiConfig {
  static const String apiBaseUrl = "https://api.themoviedb.org/3";
  static const String imageResourceBaseUrl = "https://image.tmdb.org/t/p";
  static const String posterImageResolution = "w154";
  static const String backdropImageResolution = "original";

  static String get posterBaseUrl => "$imageResourceBaseUrl/$posterImageResolution";
  static String get backdropBaseUrl => "$imageResourceBaseUrl/$backdropImageResolution";
}
