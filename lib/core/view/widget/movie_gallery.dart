import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/config/api_config.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/shared_widgets/ui_lib/cached_movie_image.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';

typedef MovieApiCallback = Future<List<Movie>> Function(int page);

class MovieGallery extends StatefulWidget {
  final Axis scrollDirection;
  final MovieApiCallback callback;

  const MovieGallery({
    required this.callback,
    this.scrollDirection = Axis.vertical,
    super.key,
  });

  @override
  State<MovieGallery> createState() => _MovieGalleryState();
}

class _MovieGalleryState extends State<MovieGallery> {
  final PagingController<int, Movie> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int page) async {
    try {
      final newItems = await widget.callback(page);
      final isLastPage = newItems.length < ApiConfig.apiResultPageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = page + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Movie>.separated(
      addAutomaticKeepAlives: true,
      physics: const BouncingScrollPhysics(),
      pagingController: _pagingController,
      scrollDirection: widget.scrollDirection,
      separatorBuilder: (_, __) => widget.scrollDirection == Axis.horizontal ? horizontalSpacer15 : verticalSpacer10,
      builderDelegate: PagedChildBuilderDelegate<Movie>(
        itemBuilder: (context, movie, index) => CachedMovieImage.poster(imagePath: movie.posterPath!),
      ),
    );
  }
}
