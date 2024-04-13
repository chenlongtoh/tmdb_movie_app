import 'package:flutter/material.dart';
import 'package:movie_app/core/constant/enum.dart';
import 'package:movie_app/core/model/service/movie_service.dart';
import 'package:movie_app/core/view/widget/movie_gallery.dart';
import 'package:movie_app/core/view/widget/trailer_preview_carousel.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';

const _kContentHorizontalPadding = EdgeInsets.symmetric(horizontal: 20);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildHorizontalLineupGallery(BuildContext context, {required MovieLineup lineup}) {
    return Container(
      height: 200,
      padding: _kContentHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lineup.toString()),
          verticalSpacer5,
          Flexible(
            child: MovieGallery(
              scrollDirection: Axis.horizontal,
              callback: (int page) async => await MovieService.fetchMovieFromLineup(page: page, lineup: lineup),
            ),
          ),
          verticalSpacer15,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const TrailerPreviewCarousel(lineup: MovieLineup.nowPlaying),
            verticalSpacer15,
            _buildHorizontalLineupGallery(context, lineup: MovieLineup.popular),
            _buildHorizontalLineupGallery(context, lineup: MovieLineup.topRated),
            _buildHorizontalLineupGallery(context, lineup: MovieLineup.upcoming),
          ],
        ),
      ),
    );
  }
}
