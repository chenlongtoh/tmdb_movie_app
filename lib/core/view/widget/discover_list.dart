import 'package:flutter/material.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/view/widget/selection_chip.dart';
import 'package:movie_app/core/view_model/discover_view_model.dart';
import 'package:movie_app/shared_widgets/provider/provider_widget.dart';
import 'package:movie_app/shared_widgets/ui_lib/movie_tile.dart';
import 'package:movie_app/shared_widgets/ui_lib/paging_scrolling_list.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';

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
            const Padding(
              padding: contentPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Discover by category:"),
              ),
            ),
            verticalSpacer15,
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
            verticalSpacer25,
            Expanded(
              child: _model.loadState == LoadState.loadingMovie
                  ? const Center(child: CircularProgressIndicator())
                  : PagingScrollingList<Movie>(
                      key: ValueKey<int>(_model.selectedGenre?.id ?? 0),
                      padding: contentPadding,
                      initialItem: _model.getMovies(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, item) {
                        return MovieTile(
                          movie: item,
                          height: 150,
                        );
                      },
                      fetchCallback: _model.loadMovies,
                    ),
            ),
          ],
        );
      },
    );
  }
}
