import 'package:flutter/material.dart';
import 'package:movie_app/core/model/entity/movie.dart';
import 'package:movie_app/shared_widgets/ui_lib/cached_movie_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:collection/collection.dart';

class TrailerPlayer extends StatefulWidget {
  final Movie movie;
  const TrailerPlayer({super.key, required this.movie});

  @override
  State<TrailerPlayer> createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  late final YoutubePlayerController _controller;
  bool _showPlayer = false;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.movie.trailers?.firstWhereOrNull((element) => element.key != null)?.key ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
        disableDragSeek: true,
      ),
    );
  }

  void _playVideo() => setState(() => _showPlayer = true);

  @override
  Widget build(BuildContext context) {
    return _showPlayer
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: const ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
            ),
          )
        : GestureDetector(
            onTap: _playVideo,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  CachedMovieImage.backdrop(
                    imagePath: widget.movie.backdropPath!,
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_outline_outlined,
                      color: Colors.white70,
                      size: 60,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
