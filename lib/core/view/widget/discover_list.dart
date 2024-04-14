import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/config/api_config.dart';
import 'package:movie_app/core/constant/enum.dart';
import 'package:movie_app/core/model/entity/discover_response.dart';
import 'package:movie_app/core/model/entity/genre.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/service/discover_service.dart';
import 'package:movie_app/core/model/service/genre_service.dart';
import 'package:movie_app/core/model/service/movie_service.dart';
import 'package:movie_app/core/view/widget/selection_chip.dart';
import 'package:movie_app/core/view_model/discover_view_model.dart';
import 'package:movie_app/shared_widgets/provider/provider_widget.dart';
import 'package:movie_app/shared_widgets/ui_lib/cached_movie_image.dart';
import 'package:movie_app/shared_widgets/ui_lib/paging_scrolling_list.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';
import 'package:movie_app/theme/text_style.dart';

const contentPadding = EdgeInsets.symmetric(horizontal: 20);

class DiscoverList extends StatelessWidget {
  const DiscoverList({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DiscoverViewModel>(
      create: (context) => DiscoverViewModel(),
      builder: (buildContext, _model, child) {
        if (_model.loadState == LoadState.initializing) return const Center(child: CircularProgressIndicator());
        if (_model.genreList.isEmpty) return const Center(child: Text("No Movies Found"));
        return Column(
          children: [
            SizedBox(
              height: 30,
              child: ListView.separated(
                padding: contentPadding,
                scrollDirection: Axis.horizontal,
                itemCount: _model.genreList.length,
                separatorBuilder: (context, index) => horizontalSpacer10,
                itemBuilder: (context, index) {
                  final genre = _model.genreList[index];
                  return SelectionChip(
                    label: genre.name ?? "N/A",
                    onTap: () => _model.selectGenre(genre),
                    isActive: genre == _model.selectedGenre,
                  );
                },
              ),
            ),
            verticalSpacer5,
            Expanded(
              child: Center(
                child: _model.loadState == LoadState.loadingMovie
                    ? const CircularProgressIndicator()
                    : PagingScrollingList<Movie>(
                        initialItem: _model.getMovies(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, item) {
                          return Container(
                            height: 150,
                            child: Row(
                              children: [
                                CachedMovieImage.poster(imagePath: item.posterPath!),
                                horizontalSpacer10,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      verticalSpacer5,
                                      Text(
                                        item.originalTitle ?? "N/A",
                                        maxLines: 2,
                                        style: MovieAppTextStyle.bold14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      verticalSpacer10,
                                      Text(
                                        item.overview ?? "N/A",
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: MovieAppTextStyle.regular10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        fetchCallback: _model.loadMovies,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
