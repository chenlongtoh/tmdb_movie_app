import 'package:flutter/material.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/view/widget/trailer_player.dart';
import 'package:movie_app/hive/hive_manager.dart';
import 'package:movie_app/shared_widgets/ui_lib/cached_movie_image.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';
import 'package:movie_app/theme/text_style.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;
  const MovieDetailsPage({super.key, required this.movie});

  List<Widget> get _buildInfoSection => [
        Container(
          height: 150,
          child: Row(
            children: [
              CachedMovieImage.poster(
                imagePath: movie.posterPath ?? "",
              ),
              horizontalSpacer15,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  verticalSpacer5,
                  Text(
                    movie.title ?? "N/A",
                    maxLines: 2,
                    style: MovieAppTextStyle.bold14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpacer5,
                  if (movie.releaseDate != null) ...[
                    const Text("Release Date:"),
                    Text(
                      movie.releaseDate!,
                      style: MovieAppTextStyle.regular12,
                    ),
                    verticalSpacer5,
                  ],
                  if (movie.voteAverage != null && movie.voteCount != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text("${movie.voteAverage} (${movie.voteCount})"),
                      ],
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
        verticalSpacer15,
      ];

  List<Widget> get _buildGenre => [
        const Text("Genre:"),
        verticalSpacer5,
        SizedBox(
          height: 30,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: movie.genreIds!.length,
            separatorBuilder: (context, index) => horizontalSpacer10,
            itemBuilder: (context, index) {
              final genreId = movie.genreIds![index];
              final genre = HiveManager().genreBox.get(genreId);
              return Container(
                constraints: const BoxConstraints(minWidth: 50, maxWidth: 100),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: const ShapeDecoration(
                  shape: StadiumBorder(side: BorderSide(color: Colors.white54)),
                  color: Colors.black45,
                ),
                child: Center(
                  child: Text(
                    genre?.name ?? "N/A",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              );
            },
          ),
        ),
        verticalSpacer15,
      ];
  List<Widget> get _buildOverview => [
        const Text("Overview:"),
        verticalSpacer5,
        Text(
          movie.overview ?? "N/A",
          style: MovieAppTextStyle.regular12,
        ),
        verticalSpacer15,
      ];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              TrailerPlayer(movie: movie),
              verticalSpacer20,
              ..._buildInfoSection,
              if (movie.genreIds?.isNotEmpty ?? false) ..._buildGenre,
              if (movie.overview != null) ..._buildOverview,
            ],
          ),
        ),
      ),
    );
  }
}
