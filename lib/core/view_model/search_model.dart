import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/model/service/search_service.dart';

const _searchHistoryPlaceholder = ["Dune", "shutter island", "THE GENTLEMEN", "Wolf of wall street", "jump street"];

class SearchModel extends ChangeNotifier {
  bool isSearching = false;
  void setSearching(bool searching) {
    isSearching = searching;
    notifyListeners();
  }

  List<Movie> searchResult = [];
  Queue<String> searchHistory = Queue.from(_searchHistoryPlaceholder);

  Future<void> searchMoviesByTitle(String searchTitle) async {
    final title = searchTitle.trim();
    if (title.isEmpty) {
      searchResult = [];
      notifyListeners();
      return;
    }

    setSearching(true);
    if (searchHistory.contains(title)) {
      searchHistory.remove(title);
    }
    searchHistory.addFirst(title);
    final movies = await SearchService.searchMoviesByKeyword(title: title);
    searchResult = movies ?? [];
    setSearching(false);
  }
}
