import 'package:flutter/material.dart';
import 'package:movie_app/core/view/widget/discover_list.dart';
import 'package:movie_app/core/view/widget/movie_search_bar.dart';

const _searchBarHeight = 40.0;

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              SizedBox(height: _searchBarHeight + 20),
              Expanded(child: DiscoverList()),
            ],
          ),
          MovieSearchBar(),
        ],
      ),
    );
  }
}
