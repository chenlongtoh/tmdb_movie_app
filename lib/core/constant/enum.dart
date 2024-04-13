enum MovieLineup {
  nowPlaying(apiResourcePath: "now_playing"),
  popular(apiResourcePath: "popular"),
  topRated(apiResourcePath: "top_rated"),
  upcoming(apiResourcePath: "upcoming");

  const MovieLineup({required this.apiResourcePath});

  final String apiResourcePath;

  @override
  String toString() {
    switch (this) {
      case MovieLineup.popular:
      case MovieLineup.upcoming:
        return "${name[0].toUpperCase()}${name.substring(1)}";
      case MovieLineup.nowPlaying:
        return 'Now Playing';
      case MovieLineup.topRated:
        return 'Top Rated';
    }
  }
}
