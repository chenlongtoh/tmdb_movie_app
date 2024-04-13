import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/core/constant/enum.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/service/movie_service.dart';
import 'package:movie_app/shared_widgets/ui_lib/cached_movie_image.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';
import 'package:shimmer/shimmer.dart';

const double _kDefaultAspectRatio = 16 / 9;

class TrailerPreviewCarousel extends StatefulWidget {
  final MovieLineup lineup;
  const TrailerPreviewCarousel({required this.lineup, super.key});

  @override
  State<TrailerPreviewCarousel> createState() => _TrailerPreviewCarouselState();
}

class _TrailerPreviewCarouselState extends State<TrailerPreviewCarousel> with TickerProviderStateMixin {
  bool isLoading = true;
  List<Movie>? _movies;
  List<Widget>? _children;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final moviesWithTrailer = await MovieService.fetchMovieFromLineup(lineup: widget.lineup, fetchTrailer: true);
      setState(() {
        _children = moviesWithTrailer.map((movie) => CachedMovieImage.backdrop(imagePath: movie.backdropPath!)).toList();
        _movies = moviesWithTrailer;
        isLoading = false;
      });
    });
  }

  bool get isEmpty => _movies?.isEmpty ?? true;

  void _onCarouselPageChanged(nextIndex, reason) => setState(() => _index = nextIndex);

  List<Widget> get buildContentCarousel {
    assert(_movies?[_index] != null);
    final Movie movie = _movies![_index];

    return [
      CarouselSlider(
        items: _children,
        options: CarouselOptions(
          viewportFraction: 1,
          aspectRatio: _kDefaultAspectRatio,
          initialPage: 0,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          onPageChanged: _onCarouselPageChanged,
        ),
      ),
      Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: CachedMovieImage.poster(
                key: ValueKey(movie.posterPath),
                imagePath: movie.posterPath!,
              ),
            ),
            horizontalSpacer10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(movie.originalTitle ?? "N/A"),
                  verticalSpacer10,
                  Text(
                    movie.overview ?? "N/A",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: (isLoading || isEmpty) ? [Text("Empty")] : buildContentCarousel,
    );
  }
}
