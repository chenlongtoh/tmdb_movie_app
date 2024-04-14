import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:movie_app/config/app_config.dart';
import 'package:movie_app/core/view_model/search_model.dart';
import 'package:movie_app/shared_widgets/ui_lib/movie_tile.dart';
import 'package:movie_app/shared_widgets/ui_lib/search_token_tile.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

const _searchBarHeight = 40.0;
const _queryDebounceDuration = Duration(milliseconds: 400);
// const _animationDuration = Duration(milliseconds: 250);

class MovieSearchBar extends StatefulWidget {
  const MovieSearchBar({super.key});

  @override
  State<MovieSearchBar> createState() => _MovieSearchBarState();
}

class _MovieSearchBarState extends State<MovieSearchBar> {
  final FloatingSearchBarController _controller = FloatingSearchBarController();
  late final SearchModel _searchModel;
  List<String> _searchHistory = [];
  String _currentSearchTerm = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchModel = Provider.of<SearchModel>(context, listen: false);
    _searchHistory = _searchModel.searchHistory.toList();
  }

  void _onQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() => _currentSearchTerm = query);
    _debounce = Timer(_queryDebounceDuration, () => _searchToken(query));
  }

  void _searchToken(String token) {
    final sanitizedToken = token.trim();
    _suggestSearchHistory(sanitizedToken);
    _searchModel.searchMoviesByTitle(sanitizedToken);
  }

  void _suggestSearchHistory(String query) {
    if (query.isEmpty) {
      setState(() => _searchHistory = _searchModel.searchHistory.toList());
    } else {
      final match = _searchModel.searchHistory.where((history) {
        final regex = RegExp("(${query.toLowerCase()})");
        return regex.hasMatch(history.toLowerCase());
      }).toList();
      setState(() => _searchHistory = match);
    }
  }

  void _onSearchTokenTileTapped(String token) => _controller.query = token;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: _controller,
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 400),
      transitionCurve: Curves.easeInOutCubic,
      physics: const BouncingScrollPhysics(),
      height: _searchBarHeight,
      width: MediaQuery.of(context).size.width * 0.9,
      debounceDelay: Duration.zero,
      onQueryChanged: _onQuery,
      onKeyEvent: (KeyEvent keyEvent) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
          _controller.query = '';
          _controller.close();
        }
      },
      transition: SlideFadeFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        final searchHistoryCount =
            AppConfig.limitMaxSearchHistoryDisplay ? math.min(_searchHistory.length, AppConfig.maxSearchHistoryDisplayCount) : _searchHistory.length;

        return Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          constraints: const BoxConstraints(maxHeight: 350, minHeight: 0),
          child: Consumer<SearchModel>(builder: (context, _model, child) {
            final searchTileCount = searchHistoryCount + 1; // History + current search term live display
            final movieTileCount = _model.isSearching ? 1 : _model.searchResult.length;

            return ListView.builder(
              itemCount: searchTileCount + movieTileCount,
              itemBuilder: (context, index) {
                if (index < searchTileCount) {
                  final token = index == 0 ? _currentSearchTerm : _searchHistory[index - 1];
                  return SearchTokenTile(
                    token: token,
                    onTap: () => _onSearchTokenTileTapped(token),
                    isHistory: index != 0,
                  );
                } else {
                  if (_model.isSearching) {
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: MovieTile(
                        movie: _model.searchResult[index - searchTileCount],
                      ),
                    );
                  }
                }
              },
            );
          }),
        );
      },
    );
  }
}
