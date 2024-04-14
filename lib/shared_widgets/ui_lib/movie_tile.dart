import 'package:flutter/material.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/core/view/screens/movie_details_page.dart';
import 'package:movie_app/shared_widgets/ui_lib/cached_movie_image.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';
import 'package:movie_app/theme/text_style.dart';

//TODO: Drop dependeny on Movie object
class MovieTile extends StatelessWidget {
  final Movie movie;
  final double height;
  final EdgeInsetsGeometry? padding;

  const MovieTile({
    super.key,
    required this.movie,
    this.height = 150,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(movie: movie),
        ),
      ),
      child: Container(
        height: height,
        padding: padding,
        child: Row(
          children: [
            //TODO: Remove this and change main display tile
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: CachedMovieImage.poster(
                key: ValueKey<int?>(movie.id),
                imagePath: movie.posterPath ?? "",
              ),
            ),
            horizontalSpacer10,
            Expanded(
              child: Column(
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
                  verticalSpacer10,
                  Text(
                    movie.overview ?? "N/A",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: MovieAppTextStyle.regular10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
